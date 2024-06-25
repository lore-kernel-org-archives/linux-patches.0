Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A6C12EBEA;
	Tue, 25 Jun 2024 09:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308633; cv=none; b=GdR6IroTO6Fwq+pOkP2LnEE+jjswS6x0P72I89tswj8FkLcIt/T8FaLBF2cdf8YI0xy9gphID1scnmU571ZmT6qlWYZs4fUNykBlCnFaGpW1Sb4/U6WLowFWqS0J/qG6T+3oIPL2vfKvMgHcF5tYx3pPv74PHFbhLvXteaWUqUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308633; c=relaxed/simple;
	bh=Vi+TK2oxcS3MrPrssIZ7NoDaX3osVWNkDMCVpfKTlvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l01AFBIFRtDv4e4RGmXQ9i4R3TbnkWZczARU6gcC4JgJSlT0HOEYVggc0F3DxI9DFmCHK13NcvWV2jN7f0PwK0mJYW/HRFWYqr+LCQ0sSCdd63Tubhsc/MMyX4PQESJf4I/JElq4cyBMxGjaMmVLHo0PvwXwfC+rDkiwHETp4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbLdOIbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbLdOIbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BADDC32781;
	Tue, 25 Jun 2024 09:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308633;
	bh=Vi+TK2oxcS3MrPrssIZ7NoDaX3osVWNkDMCVpfKTlvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbLdOIbqJSUVBMzQ5pGYUAhs6L+hklmPBGZiYx1I1jUtf1y+GXnndwPSE1knKn3m1
	 wXtd0Z5JLB4oP+4zfwb3JOKSqUlbufCaKdaSplfBxOPa5HqBWqeJ+plo4eLM4LjbO5
	 7eS/LfcNYJVwyyXkc3rSkgFk22UJGPQ2sHOjB6vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.9 187/250] cifs: fix typo in module parameter enable_gcm_256
Date: Tue, 25 Jun 2024 11:32:25 +0200
Message-ID: <20240625085555.230743188@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 8bf0287528da1992c5e49d757b99ad6bbc34b522 upstream.

enable_gcm_256 (which allows the server to require the strongest
encryption) is enabled by default, but the modinfo description
incorrectly showed it disabled by default. Fix the typo.

Cc: stable@vger.kernel.org
Fixes: fee742b50289 ("smb3.1.1: enable negotiating stronger encryption by default")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -134,7 +134,7 @@ module_param(enable_oplocks, bool, 0644)
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: n/N/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");


