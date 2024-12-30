Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1EE15E8B;
	Mon, 30 Dec 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574047; cv=none; b=Y3KFHwT+bofzkF96g+s9AdoA0SxHAOEWz69QobR/yi30BjrkBsWpGaOq4KbvaAKaYBfO7mJItst4+pIn8Yx0ivNeY+RBw03WeRr/lfYA8piJ/lhKq0RjjD4dxCXCEOHXe4dyZd2VPI0C4Yq617QlOK6E5hA0LZJe4LG37kcK8cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574047; c=relaxed/simple;
	bh=slYTp99LNrYLo2yOkk9ADu+T962w45BTF9gP7hj0mto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thMNQsB/f5cviI9WOh6t4leZS930IT8V7CLmPo/fI4c4VZiv532HecM2nj8tDhkGS4hGBZdts1xbLGv10SElnQNngzj4qNQHLoHoixrj+CPgzBUmwlw7Lpq5kFaIOGI4WyO+RRp5pY8ColORUYQlhCSVFWHuhadmQ/qc75YzUbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKX/4V2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKX/4V2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EEEC4CED0;
	Mon, 30 Dec 2024 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574047;
	bh=slYTp99LNrYLo2yOkk9ADu+T962w45BTF9gP7hj0mto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKX/4V2oOcXWkciFsObf5QJqd7X7UBTkHu+CrbNsaDMpVFfZ1WFLDER5GSN7zTv7s
	 6tfku8f+8hpT8FWNHm+nvhPei4gV+mufzVGCWLYBo7YG5IV6FIrYhRJM0zweWAvPro
	 VwMs5m5OEIDJ5sAcCWnmOWcNRCadDiviOiHxBSuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/114] smb: client: Deduplicate "select NETFS_SUPPORT" in Kconfig
Date: Mon, 30 Dec 2024 16:42:05 +0100
Message-ID: <20241230154218.382288536@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit ee1c8e6b2931811a906b8c78006bfe0a3386fa60 ]

Repeating automatically selected options in Kconfig files is redundant, so
let's delete repeated "select NETFS_SUPPORT" that was added accidentally.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 2aff6d1395ce..9f05f94e265a 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -2,7 +2,6 @@
 config CIFS
 	tristate "SMB3 and CIFS support (advanced network filesystem)"
 	depends on INET
-	select NETFS_SUPPORT
 	select NLS
 	select NLS_UCS2_UTILS
 	select CRYPTO
-- 
2.39.5



