Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0008330B30;
	Fri, 17 Oct 2025 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715782; cv=none; b=i1ZjMEeBQPqvN0gUx//f/wKVSkJc4+x9Ohs4u9+ZLPTg/ha/bHRhivaxcKMFKovDggskdF86Vil23GxVAOhhjc5ayT8MbBUheeXSFVOOByKG+6IillQdneaMRIWB5XqDsxVf7CveF2Z3MzPe2E7IE8KP51+I2BIXkMIOxjR1ng0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715782; c=relaxed/simple;
	bh=iYnrjOhAxZHbcooLxXTiM8uxLzZgrnYIbcWyG7j7Jf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co7s8Kv+S5kWH+IXsxerUeHaFshsokU8arTzl3BsKf9T4dQZRcSowU9L+UPSblfaLV2vIvKNDW0hN34ZQT0Io0AzonqbaGbDa90UOeQ/rdKFZneTXdNzYYVxPM6RR0kj+ggjPe03ipfJW/oqr15wvG6HWdQDBULwhTYVEXdIrZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/TZEiDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/TZEiDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34418C4CEE7;
	Fri, 17 Oct 2025 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715782;
	bh=iYnrjOhAxZHbcooLxXTiM8uxLzZgrnYIbcWyG7j7Jf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/TZEiDce/vqwqVxVjfNfQ5I1YJ/3q3INs0YO3mp1QclgJpxHBkQiUZnDZtJy1Aea
	 Gs8QIM/YhdlRW1hP3gbl2id20W7ADaxiKYXQKpgP/wzwOQxRxIHFlMFnkrHvV42Mfw
	 UkBzCETX9bUak7eX/V9KwxbCiD7B+TOHe20t5bpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 334/371] media: iris: Send dummy buffer address for all codecs during drain
Date: Fri, 17 Oct 2025 16:55:09 +0200
Message-ID: <20251017145214.164122606@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit dec073dd8452e174a69db8444e0932e6b4f31c99 upstream.

Firmware can handle a dummy address for buffers with the EOS flag. To
ensure consistent behavior across all codecs, update the drain
command to always send a dummy buffer address.

This makes the drain handling uniform and avoids any codec specific
assumptions.

Fixes: 478c4478610d ("media: iris: Add codec specific check for VP9 decoder drain handling")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -397,8 +397,7 @@ static int iris_hfi_gen1_session_drain(s
 	ip_pkt.shdr.hdr.pkt_type = HFI_CMD_SESSION_EMPTY_BUFFER;
 	ip_pkt.shdr.session_id = inst->session_id;
 	ip_pkt.flags = HFI_BUFFERFLAG_EOS;
-	if (inst->codec == V4L2_PIX_FMT_VP9)
-		ip_pkt.packet_buffer = 0xdeadb000;
+	ip_pkt.packet_buffer = 0xdeadb000;
 
 	return iris_hfi_queue_cmd_write(inst->core, &ip_pkt, ip_pkt.shdr.hdr.size);
 }


