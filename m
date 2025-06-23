Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6153597E;
	Mon, 23 Jun 2025 22:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716493; cv=none; b=nIoN+Pn54buKn+UR2l0gCeMFTFMjEicwCtNOV0Rw0tSH9s/yc1Kqz4y3YjZCiL4qFGkx68q63E99ywm5z1v1O22Hc6m9iBlBGcaKVcR8yBXeByk/Qwn4kN/tINm/bXFHw2nEC39gEXnYXBxvp7eK34CbgPuhsZ93N4l9WmfIkh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716493; c=relaxed/simple;
	bh=OwCnhvXAAkEoXjXhl5Skqq/3C6raom7Fo+1WFD+cV98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2PBQ+TQn2LTszvFX2mPSxj0PNSqhN87ClLrXO5XFS3V9jKphgbirH3ZJCKE9GII8plcuu3XrkX3NdOCz1caXZoo03LLhiAmhjGl/TbR+cWObgMhF2llkWhl1b2tIGpa92uKrexWt5DDqLSsKCfLeCw6VZlejWyX+eQKGsz+jUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6kOhtcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6kOhtcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A3CC4CEEA;
	Mon, 23 Jun 2025 22:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716493;
	bh=OwCnhvXAAkEoXjXhl5Skqq/3C6raom7Fo+1WFD+cV98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6kOhtcnZ/saFX49pDBJ7DOXnruBQ4w4ornVxcu5ly5o70o1fNXsWTfEi+gTtpNs3
	 9Ia+pb3j2zeQYE3KeW6y7Sm5OIxtoK5BeZ9HVkduwIJhe4Bpcs+pmGgHijHOegVUAa
	 /FmSY35XMMsoj+e6mwglAAHOxoCZB+qzDYnfw+Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/290] cifs: Remove duplicate fattr->cf_dtype assignment from wsl_to_fattr() function
Date: Mon, 23 Jun 2025 15:09:11 +0200
Message-ID: <20250623130635.645683449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 840738eae94864993a735ab677b9795bb8f3b961 ]

Commit 8bd25b61c5a5 ("smb: client: set correct d_type for reparse DFS/DFSR
and mount point") deduplicated assignment of fattr->cf_dtype member from
all places to end of the function cifs_reparse_point_to_fattr(). The only
one missing place which was not deduplicated is wsl_to_fattr(). Fix it.

Fixes: 8bd25b61c5a5 ("smb: client: set correct d_type for reparse DFS/DFSR and mount point")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index b6556fe3dfa11..4d45c31336df1 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -738,7 +738,6 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
 		return false;
 
-	fattr->cf_dtype = S_DT(fattr->cf_mode);
 	return true;
 }
 
-- 
2.39.5



