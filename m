Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1875D17B503;
	Wed,  3 Jul 2024 11:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005998; cv=none; b=g4buhPmBHdxnIiUwZzGEM7E7iVoRGwJf8Jikfh1/CeqkRDp6KvPaK2E+5Sqe3uYKXuuHNJ7C9bEcLu5eYvqr0sIUCbYlq6yp3/BDci+JOXIhqp58CgA+43ivrzo+kIlO5diyzj/uuBsVuw3FipR1jDf39C4Mzsf0UMmNpYnjXDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005998; c=relaxed/simple;
	bh=1Pi66+3P9eMUOl2OamMyx5otLmKFu79OmjDS/NKTNtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnY1lw9ups1sRuaw4RZB+AKj2bXzLtY2jqiH1sWFZESFctioV7xfbiAW6V+3r346XlSBA9voeo7PWQep40CmGZd/m0vHWG1qqjQGDXbuHarP3X89XCT70keb/wLsJpzpbZkaWbfAcEp1HexoZjO5u8CszHfKSo3lbwCQwlpfi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEEvgzwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEEvgzwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9199FC2BD10;
	Wed,  3 Jul 2024 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005998;
	bh=1Pi66+3P9eMUOl2OamMyx5otLmKFu79OmjDS/NKTNtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEEvgzwWqkHrTYfDtxBvwVna9LvZEaar70GcwUfBhtMeofagj2Z8FjicoHEisdlMh
	 plQO36jePQTD3YL6Tv3EjjIvIII6ENbApy+H+y+yuyxRlJ0u6qr5416m883YCLPcmt
	 bOrNrsAF911M96XmDggK+pa8ajOq0jB4uJ4uTn88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 266/356] cifs: fix typo in module parameter enable_gcm_256
Date: Wed,  3 Jul 2024 12:40:02 +0200
Message-ID: <20240703102923.180412452@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 8bf0287528da1992c5e49d757b99ad6bbc34b522 ]

enable_gcm_256 (which allows the server to require the strongest
encryption) is enabled by default, but the modinfo description
incorrectly showed it disabled by default. Fix the typo.

Cc: stable@vger.kernel.org
Fixes: fee742b50289 ("smb3.1.1: enable negotiating stronger encryption by default")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d3adcb9e70a66..c254e714f7ceb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -99,7 +99,7 @@ module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: n/N/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
-- 
2.43.0



