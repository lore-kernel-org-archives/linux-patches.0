Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2822BEC2B;
	Tue, 26 Aug 2025 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207367; cv=none; b=rYy6kmLxOr0dJYTqKenBHiRqpS2YtPfbN5VCid5H9IRz04XB5zGmeOGNJz7KQlu7e/NsrDqaSyYpiKZvjbys1TG2crkmwhIGbPIp5sgijHdng+q/WQE1VDfQ1j6GeEr6fAgXUbKQRfFX38Nyzu5BeGh98WiskgAUk+DTjiTv0vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207367; c=relaxed/simple;
	bh=WHaby1d/rY9eJ5uyYIMXo1G5djTYxUDf1gvdev4VtwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZHjfIohDrQCYvJ/AGE1sYRTuoU1ECzpfA96Mkk5WOJ6fcpmk4dzzceYw2sQPX7y11BEQsx9fWS6lhQTKkmTrDbo2cHz4MBYIAxNsEkbjOXl9VQKYl5jfyhYfq8/ruKxEs3GyH3KAW6MgEPZRIKDhuJpzvZzbHCBsIGUXtmcnoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Qdo6N48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Qdo6N48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F99C4CEF1;
	Tue, 26 Aug 2025 11:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207366;
	bh=WHaby1d/rY9eJ5uyYIMXo1G5djTYxUDf1gvdev4VtwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Qdo6N48k9K86vtFZur2YieEWgjPePO+xCRS4ubxogq8vZyH3eHmzHo3mHzafRXRs
	 GE088YbGQxJJi507cYoCDBSF6Ps2JbBfviH1W8ck0p5IWmLeHfTILPIYomPM5i289k
	 Nw7oMyIXM8AaAjwjC+xlCZuZLgESRgP+kGF6FKtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 155/457] media: iris: Fix missing function pointer initialization
Date: Tue, 26 Aug 2025 13:07:19 +0200
Message-ID: <20250826110941.205038239@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit c314a28cdabe45f050fe7bd403ddeaf4b9c960d1 upstream.

The function pointers responsible for setting firmware properties were
never initialized in the instance capability structure, causing it to
remain NULL. As a result, the firmware properties were not being set
correctly.

Fix this by properly assigning the function pointers from the core
capability to the instance capability, ensuring that the properties are
correctly applied to the firmware.

Cc: stable@vger.kernel.org
Fixes: 3a19d7b9e08b ("media: iris: implement set properties to firmware during streamon")
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_ctrls.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/iris/iris_ctrls.c
+++ b/drivers/media/platform/qcom/iris/iris_ctrls.c
@@ -163,6 +163,7 @@ void iris_session_init_caps(struct iris_
 		core->inst_fw_caps[cap_id].value = caps[i].value;
 		core->inst_fw_caps[cap_id].flags = caps[i].flags;
 		core->inst_fw_caps[cap_id].hfi_id = caps[i].hfi_id;
+		core->inst_fw_caps[cap_id].set = caps[i].set;
 	}
 }
 


