Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3C41D0418;
	Wed,  2 Oct 2024 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876603; cv=none; b=eVzdq6nNenV4jHQejGziz+HWhLyQU+jVJ9FH3JLi7t6SHZFwbWfKu+uEqBaXNzboMXscwO+RiFYrejioCcj1rjWbvQNgkY6ryyZMwT9EkbUKJEcFx0KgevTQSAF5Oyh8sOomtX5f28/av7OkNbuR7Xs3A4iI9G1bAFECVRDpOWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876603; c=relaxed/simple;
	bh=BmF2utuLW9PkpbMcBvUT6ctoPRs00z98XrWYpDihuS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZJ5kDS9egmVEifpccioqfq2HdDqx3C64Yb+OF7VLoLDpSjmZLpX8vWumotd8cu2EuTYTGlIdoWtXwlHGkL9yyBvsslAl+lIFO8QVHC3rs8Aoup6sGj8qeSs6WobRP0B7DklAMAb/I6L7wJ9hrGR5AqmTt1ud7p7O/Fh7ApBE30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMotecm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMotecm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F46C4CECD;
	Wed,  2 Oct 2024 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876603;
	bh=BmF2utuLW9PkpbMcBvUT6ctoPRs00z98XrWYpDihuS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMotecm3jX00rvEohqkYCKpDY8SxSw6NfpkJaPjA0jMu+oReUfP7CMSqz+8Jjlduc
	 l8MSGVF6P56cvzCZfvUKVNrvbaHAGH2HIsH57B7hE6UvlFAlVeatF34nn1QtFGGNei
	 mS6oPkJnILX9EtmlcgorPrM45ILzuzE8HV329qsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Li <roman.li@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <superm1@kernel.org>
Subject: [PATCH 6.11 501/695] drm/amd/display: Fix Synaptics Cascaded Panamera DSC Determination
Date: Wed,  2 Oct 2024 14:58:19 +0200
Message-ID: <20241002125842.478205974@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

commit 4437936c6b696b98f3fe1d8679a2788c41b4df77 upstream.

Synaptics Cascaded Panamera topology needs to unconditionally
acquire root aux for dsc decoding.

Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -253,7 +253,7 @@ static bool validate_dsc_caps_on_connect
 		aconnector->dsc_aux = &aconnector->mst_root->dm_dp_aux.aux;
 
 	/* synaptics cascaded MST hub case */
-	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+	if (is_synaptics_cascaded_panamera(aconnector->dc_link, port))
 		aconnector->dsc_aux = port->mgr->aux;
 
 	if (!aconnector->dsc_aux)


