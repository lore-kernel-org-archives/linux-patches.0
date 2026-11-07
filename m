Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064265;
	b=uvr1oorCCsDKeTh9cKr4y1afpc+ggrG8eSuULXIqU8H/SqcbP1UpxPxRe1g9EuHn1+88
	 KbaqD/AzDjvlM8uIhplVZHVI91LTsytP3xjh6BJuO7NDY7Z+eu0wZd2b8DSTzq9exST3O
	 mN0yUQuEcovVp9bby1ZNxl0gu5tkRzUc9aw0lqbXdM6CFNmhkWhrlqMsVE5WoE520AbR3
	 e5K5nidrLbkn18xbdhORWzhEc5rxJCbzfIdMTRLdomq4ZFTFwchnIb+zUIFxqkIGvlpy9
	 nRyCcINZvLGMhIDAA/HZNoa3tp/jCiM/dlqUMQqeCR2L1kC3AL3X2JMEhTpo6H7la4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fVbIARVQsQmC/r2eNAnWFtmZEOWM424WazY9ORQYyE8=;
	b=X6hj0+DJl35bosy0OUxqZhp20TnP5TfceCl/3DTJEEvkPT0IjBBfvgE45C8WNyUfeJPO
	 kut9YUraATaKYV7KGfy2xoAL6N2ENQVx7DM4Klmg8qaWh7FbOjeAhiAV0/VGEz91vGni2
	 TCvsGsCWN016/t7vKpVU2tAHTlfWRvtyqgtIU7OeFHrSD7G/khDgbLCdc/KDObgw63cFy
	 Dyk52hMQftvIel1ZrT4lTA+9AZQ0koBmeUDhf2h17h0JJOm9hoA6+Q1UEVsgXbIJ+vga6
	 F3cXzGql/vxk/Pd+0+RFfpqTt4iLk0Nx5tJDuXiGSPl8b0Z/QSyLT3PchKoN/kpLpCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaGharVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89484606A334;
	Sat,  7 Nov 2026 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZaGharVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3870C1F0089F;
	Sat,  7 Nov 2026 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064265;
	bh=fVbIARVQsQmC/r2eNAnWFtmZEOWM424WazY9ORQYyE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaGharVGwiEyt92WgBbI7xHJgnHO2Fba1qnW7LJ81p0rvMCIIaGcBXDQ1/OJ6n+w0
	 aKAv7nu6h/4TbCvZQWDMHFbwaK56ldF5jbavXS0fnFmzGyBXGwJhZIFRf3KSF4/gK8
	 zazqBrdR7PYF9Aqd1dQbyeSULvWrCauKZkg5PWAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0364/1257] media: iris: avoid bit depth validation for capture formats
Date: Sat,  7 Nov 2026 08:44:20 -0500
Message-ID: <20261107134949.637664641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>

[ Upstream commit 40e9c3b3e35c6d65a3a0d3b1483716ad48b046bd ]

When validating a capture format, check_format() compares the requested
pixel format against inst->fw_caps[BIT_DEPTH]. However, the bit depth
capability is not available at this stage and it contains the default
value of BIT_DEPTH_8. The actual bit depth is updated later after the
firmware reports stream capabilities through read_input_subcr_params().
Because of this, a valid client request of QC10C format request is
rejected during the initial format negotiation. The driver then falls
back to the default capture format (NV12) and stores it as capture format.
Later, when the firmware reports that the stream is 10-bit, the driver
sees NV12 as the selected capture format and switches to the default
10-bit format (P010). As a result, the original QC10C format requested
by userspace is lost and QC10C decoding cannot work correctly.
The bit depth information is not reliable during the initial format
setup, so it should not be used to validate capture formats. Remove
the bit-depth checks from check_format() and only verify that the
requested pixel format is supported. This allows the format requested
by userspace is handled correctly.

Fixes: 20c3ef4c7cae ("media: qcom: iris: vdec: update find_format to handle 8bit and 10bit formats")
Cc: stable@vger.kernel.org
Signed-off-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vdec.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vdec.c b/drivers/media/platform/qcom/iris/iris_vdec.c
index 9e228b70420e4..7f89e745a4b1b 100644
--- a/drivers/media/platform/qcom/iris/iris_vdec.c
+++ b/drivers/media/platform/qcom/iris/iris_vdec.c
@@ -95,16 +95,6 @@ static bool check_format(struct iris_inst *inst, u32 pixfmt, u32 type)
 	if (i == size)
 		return false;
 
-	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		if (iris_fmt_is_8bit(pixfmt) &&
-		    inst->fw_caps[BIT_DEPTH].value == BIT_DEPTH_10)
-			return false;
-
-		if (iris_fmt_is_10bit(pixfmt) &&
-		    inst->fw_caps[BIT_DEPTH].value != BIT_DEPTH_10)
-			return false;
-	}
-
 	return true;
 }
 
-- 
2.53.0



