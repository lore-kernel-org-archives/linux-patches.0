Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214046;
	b=iwjvGAQnmVyefPxjT6oo5tXFA7Gk/4PvcyMvIQgJbIXsys4RJeJGJ1GX8pFykahGI2yH
	 ze187kpVWNmh2+z0314Spbr4UbAVp39qoe8uHRLdlFqwXwd19oIOtt9lgmt5ZLcup9ri8
	 edEuJnqEGYfOBTT+/WFTH9mJz3dJvgw5tTe3idOh6lvUpnmel13//ctK4gABvBoAI8zUs
	 nJMGQBa1ErAJ1raaeWBUp1c8yeGB0sXcvO3tnuwlEWlQ/+AqRDOL5KiFE8lw4kAS4AACD
	 KEhlKR+iHc+nNkhQrwiMdGzUmCiyyZlkjYKBAo5ZdQzfFio1xonEsS/R8GFO+n4qMRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pnq6Zf+UpSrM0hp78unZi2H5XBEKNjTNtrwTTrUDYOc=;
	b=0a7F09lIX5Soeyalf2Xcuca9RRkF1ol49P85Jo4Jj4uecSiIbJg3BIX/lJZN5d3hA8Si
	 yFNlTI4eVk6ufreZXfS3Cez2g4X3nePGniSChSf8UBUt3jITSVxvF3dzxJSF+v/fHfaNT
	 7IYfPpMYIcZdiWM5B2EmqVETGXRJHp6giLvJooYlH36snWNWnobTSEixMBjLmj5bKOWmE
	 rN5+7i2LSdF82P2FhI/5CPd+WIdlyXnCGDxNvCIHGCFU6qzWUErr7O9aChEDgCtcr7Kl4
	 9IC8F8OENv5k92SseEF+2puuYNdvUE7pbXxq/PiHragv/T1g3tCTIxhBNBfvcMeZOFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMgulnTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC13B606A32F;
	Wed, 28 Oct 2026 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMgulnTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170C01F031E1;
	Wed, 28 Oct 2026 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214045;
	bh=Pnq6Zf+UpSrM0hp78unZi2H5XBEKNjTNtrwTTrUDYOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMgulnTbUBbabCHd5GiZvICMOBkceVjun1nRWH1AnL+/8vWqF4Kveyod2ZOFg3MMe
	 XHI3idOlfvr4New828dZJQF83nnkdtzGvFxDFkDiXI0+Oe5WPnllVmw6IXZd9fberK
	 34AzrsU3QUnOVaUVkHXfLDGMpmtDDOFmADnBrQdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0676/1887] drm/amd/display: Implement bounds check for stream encoder creation in DCN401
Date: Wed, 28 Oct 2026 17:46:12 +0100
Message-ID: <20261028170514.794216624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit bdf606810210e8e07a0cdf1af3c467291363b295 ]

'stream_enc_regs' array is an array of dcn10_stream_enc_registers
structures. The array is initialized with four elements, corresponding
to the four calls to stream_enc_regs() in the array initializer. This
means that valid indices for this array are 0, 1, 2, and 3.

The error message 'stream_enc_regs' 4 <= 5 below, is indicating that
there is an attempt to access this array with an index of 5, which is
out of bounds. This could lead to undefined behavior

Here, eng_id is used as an index to access the stream_enc_regs array. If
eng_id is 5, this would result in an out-of-bounds access on the
stream_enc_regs array.

Thus fixing Buffer overflow error in dcn401_stream_encoder_create

Found by smatch:
drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn401/dcn401_resource.c:1209 dcn401_stream_encoder_create() error: buffer overflow 'stream_enc_regs' 4 <= 5

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
index 85430e5baa455..4a1be0e371288 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn321/dcn321_resource.c
@@ -1208,7 +1208,7 @@ static struct stream_encoder *dcn321_stream_encoder_create(
 	vpg = dcn321_vpg_create(ctx, vpg_inst);
 	afmt = dcn321_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt) {
+	if (!enc1 || !vpg || !afmt || eng_id >= ARRAY_SIZE(stream_enc_regs)) {
 		kfree(enc1);
 		kfree(vpg);
 		kfree(afmt);
-- 
2.53.0



