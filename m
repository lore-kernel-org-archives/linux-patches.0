Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037819;
	b=OsPTa26CU2vSl3svJTzHnnB+U51HrAtfAhT0wd0KyoxWJsfxpk2wClycm6j+QOCK1WGc
	 uRxfp1SAja16N/3PoA6v57MeC6C/QGCaB6rhxL5MEiZ6Iq1q1OAI7pRsuVogNtWF3GZox
	 ciqFniOQaN1w99IsN+R5Zr+Z4i+pLdiyPIu2W/fgS4FcQR83SIgMuAl6dvbujPTI3iupo
	 +cFrA5qmvp3czoo2aR/OFXAfKQjrAJjA9nsthB2OKvlwKCCsa+yV4jL7H2GQlbFKl8pnx
	 u+3WdB8lERN3+Cfgw90ltzAAboEQl8bhulU6WQSJOADqteb+9ZNKA4NNu0vZozq111g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sFjOTa65Mx2Sb9g38mzONQ/88zwGJGZK/YHFNEvQ9xQ=;
	b=EHfH0BxshHLml4oJmJU8FmD3jkuGQSXM/zM3eK292IgQjqocAFcSmaRbGyKt6RmApAEU
	 SjKxFsURCnFFySJagn5Ju3h/TcI1bi2jK2fVkg+Pfgo9yvoe0sp6o4ErTRg2Ell5VJgPt
	 XIv5dmQQQcFrdx/kmH+QssWhLmk2rBA6jeAs9ligyT6C2N8LS2reWSogeZHTIDTRmn+xF
	 u3ecbIKsGMqfltm6kjwl9Hyv0hLpsVFKCAWWNbrv3bnYbIv8WjVBDE1asqi5tzKrFA3nB
	 ldn4zjDP0+xkba+/lJQaNQ7iGey+n33hUTEKBsE9WNOjWm9IyRK1Th+FHakTbnsjQzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKJnFKn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD74606A336;
	Wed, 18 Nov 2026 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKJnFKn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B3B1F000CA;
	Wed, 18 Nov 2026 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037819;
	bh=sFjOTa65Mx2Sb9g38mzONQ/88zwGJGZK/YHFNEvQ9xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKJnFKn9R4W1LaEK9GZp8yFZWKb5y1F5997vxJ1baCHqFAa3U6ARmS4bUQxy6qJQi
	 CYNZscqGuzdmvTsSVGp+rZbsSCe6DVsuQFFLELAA2CkJo+ulx1E8xlt4HbmYQfmTvw
	 lwFUS39OM16U8tPM72Ar8CCI3Hi9RmBJeJbpLsDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Zuo <jerry.zuo@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1530/3318] drm/amd/display: Avoid closing unowned DDC pins
Date: Wed, 18 Nov 2026 15:35:52 +0100
Message-ID: <20261118150406.871221589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit e7ba638b8116cb5f1a5690f543052371215f1626 ]

[WHY]
dal_ddc_open() cleans up pins it acquires on later failures. If the
data-pin open fails, this attempt acquired nothing. If opening the
clock pin or configuring fails, dal_ddc_open() closes the pins it
opened. An extra dal_ddc_close() is unnecessary and unsafe:
GPIO_RESULT_ALREADY_OPENED can mean AUX owns the existing handles,
and closing them here would disrupt AUX.

[HOW]
Remove the extra dal_ddc_close() from the failed-open path.

Cc: Jerry Zuo <jerry.zuo@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 175ae7772b68757b4932f34ff862923cab7abe21)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/link/protocols/link_dp_capability.c  | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
index 8ffa6739640e5..3feeb8863a950 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_capability.c
@@ -2269,12 +2269,8 @@ bool dp_is_sink_present(struct dc_link *link)
 	 * which indicates we need additional delay
 	 */
 
-	if (dal_ddc_open(ddc, GPIO_MODE_INPUT,
-			 GPIO_DDC_CONFIG_TYPE_MODE_I2C) != GPIO_RESULT_OK) {
-		dal_ddc_close(ddc);
-
+	if (dal_ddc_open(ddc, GPIO_MODE_INPUT, GPIO_DDC_CONFIG_TYPE_MODE_I2C) != GPIO_RESULT_OK)
 		return present;
-	}
 
 	/*
 	 * Read GPIO: DP sink is present if both clock and data pins are zero
-- 
2.53.0



