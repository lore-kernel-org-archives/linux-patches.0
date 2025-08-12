Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDA11DB92A;
	Tue, 12 Aug 2025 18:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023820; cv=none; b=hBiQZR8DVRX1rIBNy+5vHIN5hxAMG9uhNBmO+0/Pof3TVVlj7JNmWWetAFmJZg4Vt2nO4sic3T8zLhQUAEk+Ky7XZ89+bV3HEE4/DR93vxlmWANxUbAwwBhuSxcRxmNm74lAqhdRROcD71Wf5C7Vw1TQbqFEyEISlQwKJDO1kAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023820; c=relaxed/simple;
	bh=c7KuCx9Bs4CRsuF7vKWCA7eKuy5F0woA0HS3Tf0+uRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJFAwRzqlBS/DoigS68K4FUC4h8SgH8O9c760yR67Ux9oKOALzc+smJ5E6UkFepTUYVIlSkyqTHQDxvfpyF+D9FNeE5SHM1KnTRul5GCyu3FKRL5POR5317LnLSiS9oO4ryxKmQ/iFyCkxZSChSYFzZyNIaMnVqZeXICitUS5o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOSeeaZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOSeeaZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87EDC4CEF0;
	Tue, 12 Aug 2025 18:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023820;
	bh=c7KuCx9Bs4CRsuF7vKWCA7eKuy5F0woA0HS3Tf0+uRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOSeeaZNMYsspzv+GFE34P4mw0vM16i6DW9xbzbUfnmlaVj6MfT+DRIKsbh9rmyOe
	 X87fqndogcuR49jOhoAGxIb2TFDph6PozFKEXPGxCaEsxo6LbYkDFIAamnr1oN1wPW
	 KHO/huHCG2d/shtaUeywmrfNwQN7u1m34GFHqP9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 191/627] drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value
Date: Tue, 12 Aug 2025 19:28:06 +0200
Message-ID: <20250812173426.536377130@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit a54e4639c4ef37a0241bac7d2a77f2e6ffb57099 ]

There is a small typo in phm_wait_on_indirect_register().

Swap mask and value arguments provided to phm_wait_on_register() so that
they satisfy the function signature and actual usage scheme.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

In practice this doesn't fix any issues because the only place this
function is used uses the same value for the value and mask.

Fixes: 3bace3591493 ("drm/amd/powerplay: add hardware manager sub-component")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
index 79a566f3564a..c305ea4ec17d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu_helper.c
@@ -149,7 +149,7 @@ int phm_wait_on_indirect_register(struct pp_hwmgr *hwmgr,
 	}
 
 	cgs_write_register(hwmgr->device, indirect_port, index);
-	return phm_wait_on_register(hwmgr, indirect_port + 1, mask, value);
+	return phm_wait_on_register(hwmgr, indirect_port + 1, value, mask);
 }
 
 int phm_wait_for_register_unequal(struct pp_hwmgr *hwmgr,
-- 
2.39.5



