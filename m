Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8826B63A1;
	Fri, 24 Nov 2023 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4IPqJSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174A8C433C8;
	Fri, 24 Nov 2023 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852352;
	bh=T8GbqL7gpb3XziMuVTfNe0gpt9m8KzJe+oY4S67DA3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4IPqJSor6/8Z0c3gsBC54wmFDh+pnG4AT4sC9GX9f9P+qt3oqSMb0PgPl6tR5wkC
	 WACz5ClYNslNBaattQ4IdzYTW8SXRCM5nJreoh3MXW++/7akadCp+qoFZj19JetOGE
	 Q+vpxo0c+abTQm7em96hZhS1Tj1StwV4hdY9r+7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Hebert <nhebert@chromium.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 321/372] media: venus: hfi: fix the check to handle session buffer requirement
Date: Fri, 24 Nov 2023 17:51:48 +0000
Message-ID: <20231124172021.098006067@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit b18e36dfd6c935da60a971310374f3dfec3c82e1 upstream.

Buffer requirement, for different buffer type, comes from video firmware.
While copying these requirements, there is an OOB possibility when the
payload from firmware is more than expected size. Fix the check to avoid
the OOB possibility.

Cc: stable@vger.kernel.org
Fixes: 09c2845e8fe4 ("[media] media: venus: hfi: add Host Firmware Interface (HFI)")
Reviewed-by: Nathan Hebert <nhebert@chromium.org>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_msgs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -374,7 +374,7 @@ session_get_prop_buf_req(struct hfi_msg_
 		memcpy(&bufreq[idx], buf_req, sizeof(*bufreq));
 		idx++;
 
-		if (idx > HFI_BUFFER_TYPE_MAX)
+		if (idx >= HFI_BUFFER_TYPE_MAX)
 			return HFI_ERR_SESSION_INVALID_PARAMETER;
 
 		req_bytes -= sizeof(struct hfi_buffer_requirements);


