Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADDC158870;
	Tue,  9 Jul 2024 11:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524536; cv=none; b=hOrLTuj+a6TpXnuvnDAe6XFLoQ/wPbGMhcFUBoM6jRjGAbvhoMT9hOVoqDn2MUVvo6MMveDmxINjZGin3CZTnhgGtNtOvdAPfFpchzHL8NR4g4cT70NPUgb3Uu3eX800bDNIUAEDBdKYQwKZmKVAzXG0K5SxIQJaJuTllrX+6gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524536; c=relaxed/simple;
	bh=A2iXBQBapyUTv30zPIPyAYtXFg/Z9b7PgLJ2sHlpPrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMq2GXgUT/dWqlG5oU+Mk93mRD8rqy3jf2AHecxqSXn/5/6wVyTgyf+23ZIAY9F+qwJUn9kJXZ2ymsfUB+wwpQK7D/HutB+JcTkm3IH3yYsPtZTxn5cKwKX9eGLKsm6i3+s400HF+u8ty13DoqXVPO19FvaXKRNnW4SVbc9PFmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyU8ZHQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyU8ZHQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA58C4AF11;
	Tue,  9 Jul 2024 11:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524536;
	bh=A2iXBQBapyUTv30zPIPyAYtXFg/Z9b7PgLJ2sHlpPrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyU8ZHQDlPQyLpIOYbsDkjFCFjmkwkcOashnhp1xC0PUbCunaKuMC1H8Q6mEepzJy
	 yk1LcyzfXGFCDaWpRvIdP6z57axVJp/8+SvJf/5LA68I3pJuGNIc9cask3NRPAh6XH
	 vl7+DTzwKQLeKNa3OHjn4HCP1dbeGF5CIZ0UqtI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/102] drm/amdgpu: fix uninitialized scalar variable warning
Date: Tue,  9 Jul 2024 13:09:39 +0200
Message-ID: <20240709110652.001360023@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 9a5f15d2a29d06ce5bd50919da7221cda92afb69 ]

Clear warning that uses uninitialized value fw_size.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index b803e785d3aff..e9e0e7328c4e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1004,7 +1004,8 @@ void amdgpu_gfx_cp_init_microcode(struct amdgpu_device *adev,
 		fw_size = le32_to_cpu(cp_hdr_v2_0->data_size_bytes);
 		break;
 	default:
-		break;
+		dev_err(adev->dev, "Invalid ucode id %u\n", ucode_id);
+		return;
 	}
 
 	if (adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) {
-- 
2.43.0



