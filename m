Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1F22141CF;
	Tue, 12 Nov 2024 10:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407777; cv=none; b=QpUL6bXj87GS9ZpD9nn8dNwyvAOryEa1oJXUQMVCFpRZg7CVrNvmxKFBkyvAhUJbdO/07+zef+pG1UA6PrZndgo+rIvwKpusboSHDff+9SmPDK331HsyuC3059jwRLKdtBIVIUjvpDefBAsbFhIxQUe/DY/kh99MNqnf9LuST6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407777; c=relaxed/simple;
	bh=wjyNy990E69z4uXvJ400mhpRL4upZBOWlhmmQF+NHDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7ko1BbUOTJQ8DGb2cjYC09Z023Yip9WgW1IfWSpWR3Zt7pG6GAbqbwu6lI11OKli2rB9oSZRx+6N09J4c1aCyMDNOjMRBxe4+EcS+xdl3+osY48+FB23EWCxO6lirS/+aK1kWlMjP/5afZu9dd0EFX9ig/XNMYj7MQkpFb//Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E79LpM7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E79LpM7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C61C4CED4;
	Tue, 12 Nov 2024 10:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407776;
	bh=wjyNy990E69z4uXvJ400mhpRL4upZBOWlhmmQF+NHDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E79LpM7naRuIag0I+axSIak7EvowzEi7SoRKVOlKe3Nl4J4X14yLw4zyFqRigDE8N
	 jeEsDz6LZnAUX1jgoUeBOq2iRQqH5w8dVFLwda0kN6OFkFl8RR/e7rHAZje52pPZMH
	 IvOMHFPxmAojxCWbX6DD+xyqzg2jBVCO3C4mkz/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 079/119] drm/amdgpu: Fix DPX valid mode check on GC 9.4.3
Date: Tue, 12 Nov 2024 11:21:27 +0100
Message-ID: <20241112101851.737919941@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 3ce3f85787352fa48fc02ef6cbd7a5e5aba93347 upstream.

For DPX mode, the number of memory partitions supported should be less
than or equal to 2.

Fixes: 1589c82a1085 ("drm/amdgpu: Check memory ranges for valid xcp mode")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 990c4f580742de7bb78fa57420ffd182fc3ab4cd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -440,7 +440,7 @@ static bool __aqua_vanjaram_is_valid_mod
 	case AMDGPU_SPX_PARTITION_MODE:
 		return adev->gmc.num_mem_partitions == 1 && num_xcc > 0;
 	case AMDGPU_DPX_PARTITION_MODE:
-		return adev->gmc.num_mem_partitions != 8 && (num_xcc % 4) == 0;
+		return adev->gmc.num_mem_partitions <= 2 && (num_xcc % 4) == 0;
 	case AMDGPU_TPX_PARTITION_MODE:
 		return (adev->gmc.num_mem_partitions == 1 ||
 			adev->gmc.num_mem_partitions == 3) &&


