Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018121;
	b=DyJiX1NBXUqq1HInC3R94Pp7D+YQo13nrnpeWccbenGW0rTHupSuoG2b1IV9eIk2LAh5
	 /Sian5tF7EikcsB7+p8JYnYtA59WXHyakJ5+fXb2ASu4MlQbqpQ9Mtqyntim+n4ahrH5T
	 K1UEY5P2PIJIU1Xw87S3jvm+FsZt19SPGuaftM3Fl5AbW3Slz3ac4OTDH3hUqPtxK3ocH
	 2PO4QISNIx+IF63l42d+i9eWwJ3vL92VdAz66wzgsz9clpVVjrNhEiTvZikDcHrdWFjRQ
	 fLgI0PfAqE5Eimzw6fGnQXTX6kp8pmXDuwSJbFqRulU4YKbsvl3iBYc0BPO2Ux60liw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P3uHiwaLsN9QcqiPsOxuLr/zVQKil4WvNDABX7ucbuM=;
	b=v1moRboRtEI+uIkq0VnuUC04OLxsOjZ+HEgmDHC+MbequwONzmxRnsXhcyFfMrvTLdnw
	 iUnvr5FamiTwncud1UkpRL8S5cyq61lyWwTY+MapiD9kHg4FOjWVdvL/JZmmruKJkkC/u
	 VymiXOwyEJA9cF+MKx1GypBPdm1V1F2htRmh20i8jICrZxC1eqGhMW3cyFKAruHlg1pWI
	 x8VqmxIzF4SCfCnpfSFFZ1w8ofEriJvYP3TVTfN9H9lAvqUv9+scm9xZO1ta0Vsqa/Y3Q
	 CuXcBxrc7P/vNb+kgsRY4VuEol4r/56FO/qnaUu/R9ZHJUs00ZJgSnvmBv+t3o0qIrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsqyOcgz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49239606A332;
	Wed, 18 Nov 2026 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wsqyOcgz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569041F000C4;
	Wed, 18 Nov 2026 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018120;
	bh=P3uHiwaLsN9QcqiPsOxuLr/zVQKil4WvNDABX7ucbuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wsqyOcgzAaauzZPPUfqhZXAIr4DExz7pVaYOeQWzyMO4LEdF+mefYIIWjWa8UAXqc
	 jEcfngH2wVmxMRGvPYkZBN5mnVabLUPOnDBVWFQPyetGRktSMcNrrwqRO4vbKX5bpl
	 ncrs5BN/ReVT7Ps+thjYAe9qH49SxEq0PhduK1Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1128/2651] drm/amd/display: Enable dcn42 pstate pmo
Date: Wed, 18 Nov 2026 15:39:28 +0100
Message-ID: <20261118150328.624870681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>

[ Upstream commit 0d07b189787617a8f2d62e0d2c67573b590a36ff ]

Set a flag to enable pstate pmo, we want to always allow pstate
support on dcn42

Partial application: DCN42B resource constructor only.

Fixes: 6352e6027307 ("drm/amd/display: Enable dcn42 pstate pmo")
Signed-off-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/resource/dcn42b/dcn42b_resource.c    | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn42b/dcn42b_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn42b/dcn42b_resource.c
index f36d0f828166f..8e5bc0276abbb 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn42b/dcn42b_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn42b/dcn42b_resource.c
@@ -2422,6 +2422,8 @@ static bool dcn42b_resource_construct(
 	/* SPL */
 	dc->caps.scl_caps.sharpener_support = true;
 
+	dc->dml2_options.pmo.force_mandatory_uclk_pstate_support = true;
+
 	return true;
 
 create_fail:
-- 
2.53.0



