Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F016117332C;
	Tue, 26 Aug 2025 11:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207446; cv=none; b=nXfULno82huAOscrIB+Km2mi3/wjd5flh+Ax6RgF3uPLW0y4OOpRA7e1Tn8qNsXjrsVEwrREAkSUQanEnp5ovmVludSJ9BCspmfiffgAcDZW+NLNAkEfsVQ3k2lzTUSM69+RgVtI4cxKE+G2Qqw8TjQEu+b8W+dbWWk8jdU2KJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207446; c=relaxed/simple;
	bh=76OoYE1XfQHGy0RBfP+YTDZmU8MBHbzxk++E4NQleE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq+Cm55XuMkIZxwY0zwEbbFWByly0ewK6l5z7AdQc2vzg7cZ1teSfE1FEqFNCu2muT6WDh7SmQA0nQhaKkzJgxNsqzG9LaR0O2vX7CizfN0tqIi1rC1jOXuD1p2c0yRX4+c8LP70Vfq+W2hgrDYB19atZhAkjC4/mXxaE2StO8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOA0eNgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOA0eNgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E121C4CEF4;
	Tue, 26 Aug 2025 11:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207445;
	bh=76OoYE1XfQHGy0RBfP+YTDZmU8MBHbzxk++E4NQleE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOA0eNglYDdqrLOyeecSbM7BVjKqvHkSfmqUAGmBUExfSsWkNPWqKhxKhmWEQU18L
	 cCt6F7cyjbRsDz05CXGf4oTIcuYb4a3eWnWrCTJmjSv8lOxNaA18LPgTVAy2vRXppL
	 0ZSJm2sx8fkBJtpn1VIMPmhL9zfrfVUPz944bF74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 153/457] media: iris: Drop port check for session property response
Date: Tue, 26 Aug 2025 13:07:17 +0200
Message-ID: <20250826110941.154187907@linuxfoundation.org>
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

commit f3516f856d1f11d9dff7d72491d474a2bae1cf8e upstream.

Currently, port check enforces that session property response must
arrive only on the BITSTREAM port. However, firmware can send some
responses on other port as well.

Remove the strict port validation to correctly handle session property
responses from the firmware.

Cc: stable@vger.kernel.org
Fixes: 3a19d7b9e08b ("media: iris: implement set properties to firmware during streamon")
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
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
 drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
index b75a01641d5d..d1a2a497a7b2 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen2_response.c
@@ -636,9 +636,6 @@ static int iris_hfi_gen2_handle_session_property(struct iris_inst *inst,
 {
 	struct iris_inst_hfi_gen2 *inst_hfi_gen2 = to_iris_inst_hfi_gen2(inst);
 
-	if (pkt->port != HFI_PORT_BITSTREAM)
-		return 0;
-
 	if (pkt->flags & HFI_FW_FLAGS_INFORMATION)
 		return 0;
 
-- 
2.50.1



