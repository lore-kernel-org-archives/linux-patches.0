Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B77393DD1;
	Tue, 26 Aug 2025 11:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208467; cv=none; b=r3fxxaOQBYRTvm9U/AGj5x9KZG4+s2Se5Zqiq/F0AXV6H2IwF4g974LKK3w8OuJNY9PD6TLtgzqDaGGAcJopEFx/tupyPHNRlxp9u2XNJW2c9MMlV/KnR0EdaCXLpkvLSyl4q7us8K0ZTmyrU98RRP9L6z+wfoKPWSo11Rki2o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208467; c=relaxed/simple;
	bh=FtFRlrD587Axszw4cC6IEaJh48jiIvHwazaBZEAjzIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YbVjcRDmwLpheyEhZGwPmin8s6XWK0/PRl/hDNgSTdMA0c/Vp7/kxjpSewAggpVtfgo3xsT4Gnn8r7m8KBeugYrrwfGnlVUHS6cWL00M7uu20lME0bbunTj3hApAyk1kIh9RFTiEcKwGgwXi2Cz/CzW4EYWbYg9I/2aiW5ko/xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJcGEydI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJcGEydI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7FFC4CEF1;
	Tue, 26 Aug 2025 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208466;
	bh=FtFRlrD587Axszw4cC6IEaJh48jiIvHwazaBZEAjzIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJcGEydIUrV3JAIEF40JvsIIWq/bD/8DfSsR1XOOVlaqV+4P1o7GOOUWfVoUdVVKR
	 j/Eo6z9sEIzfRuAF7yt7R55Ne0zx/uS8gdlYMa3SKBqWM78VC1i2wIOi5UY5d0OW60
	 8CQ/pqwOek2mnB43eHFjM3mCWQ/wrZvqzX1jAcTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 123/322] drm/amdgpu: Update external revid for GC v9.5.0
Date: Tue, 26 Aug 2025 13:08:58 +0200
Message-ID: <20250826110918.835764517@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 05c8b690511854ba31d8d1bff7139a13ec66b9e7 upstream.

Use different external revid for GC v9.5.0 SOCs.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 21c6764ed4bfaecad034bc4fd15dd64c5a436325)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1183,6 +1183,8 @@ static int soc15_common_early_init(void
 			AMD_PG_SUPPORT_JPEG;
 		/*TODO: need a new external_rev_id for GC 9.4.4? */
 		adev->external_rev_id = adev->rev_id + 0x46;
+		if (amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 5, 0))
+			adev->external_rev_id = adev->rev_id + 0x50;
 		break;
 	default:
 		/* FIXME: not supported yet */


