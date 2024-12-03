Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A681F706C;
	Tue,  3 Dec 2024 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238439; cv=none; b=h+YIyHKJxOAGFqvJRDyKEhM7Cx9u0uA83uObC4f9q79c2e6EhxGzGMtcbCPpLM5Nb3cdebUEH5JdEt+Q84cPCyeWvnHXTpUVrPSXDTEmyEuYu75n4Zd2YgqYB8sHDbp91XHMpsTlfFv3rk7BE3EI3YMFfU7Xnv4uvuz2kuq822s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238439; c=relaxed/simple;
	bh=a6fWI4HPBZYzAT4fPcfZWz09WYM7XHHCwC35LDZKHf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IS6zmv/isvFCmg6jzqTGMHYmqxpL5ZYdUD201r1sAJ5znCOfcBiz++iK45V4kqny3ZSbL5lM6MFPnsvrE518wsgsE6JszUWlctefi7ONCIFGLv4bBplgdl3U4xwp2kRaz1U6LTv8T35SNfr11rNhnA2FTwVWuxggcc9+Cb3s8q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNThT+Fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNThT+Fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DFEC4CECF;
	Tue,  3 Dec 2024 15:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238439;
	bh=a6fWI4HPBZYzAT4fPcfZWz09WYM7XHHCwC35LDZKHf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNThT+Fc4i/ninnUl/NhlM7ZC8KkqZ0HZD3leQewHrI6zMdgJOiZmV5w16hhwBXC1
	 Otu6i+7NaP6B7002/fAQpuGvlZcjqbePedfGTPsOxjb9F82e5f0jDq4Ziok2aP2CDl
	 qv9a22MoeRm7sk6Va4OMGW3ICvXihZ3GKFTE+lJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 270/817] drm/vc4: Correct generation check in vc4_hvs_lut_load
Date: Tue,  3 Dec 2024 15:37:22 +0100
Message-ID: <20241203144006.335856132@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 42aa18d1c3e7762bcebd89a5857ed7774e669d92 ]

Commit 24c5ed3ddf27 ("drm/vc4: Introduce generation number enum")
incorrectly swapped a check of hvs->vc4->is_vc5 to
hvs->vc4->gen == VC4_GEN_4 in vc4_hvs_lut_load, hence breaking
loading the gamma look up table on Pi0-3.

Correct that conditional.

Fixes: 24c5ed3ddf27 ("drm/vc4: Introduce generation number enum")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/dri-devel/37051126-3921-4afe-a936-5f828bff5752@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008-drm-vc4-fixes-v1-3-9d0396ca9f42@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hvs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 50bfc514943a1..df71bc68cdd00 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -224,7 +224,7 @@ static void vc4_hvs_lut_load(struct vc4_hvs *hvs,
 	if (!drm_dev_enter(drm, &idx))
 		return;
 
-	if (hvs->vc4->gen == VC4_GEN_4)
+	if (hvs->vc4->gen != VC4_GEN_4)
 		goto exit;
 
 	/* The LUT memory is laid out with each HVS channel in order,
-- 
2.43.0



