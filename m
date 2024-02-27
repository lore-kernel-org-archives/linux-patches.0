Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D7013EFE9;
	Tue, 27 Feb 2024 14:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043577; cv=none; b=Wdolai+qAd3KUvyLtdBRMYB11QV7le0D/XXy3P40I8QkwxDlO44Evt5OgrCDFH0tYxKKMrR3KksgbDWK776PfG+3fnxtBNM0NadZndmIY+xkd32pz/s5pTU0SofXNVvvssMfLoASvwDtLnNuPNVF8rWIRMpo+IdDNKruc/+PrtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043577; c=relaxed/simple;
	bh=GxBJax4VLy6D9jQ4iQjQCiF2fX/pATUMbiN0m4bCitg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRcbkXPMFK5CQlPQx2VNTOA2bafCPjf/rrcDxDkes20lUPpUWMFUlULzWGXQlzlG12b9NARNWc71o5busiEPG3u0aoELXG+d+SvfbpHmOjIqR3ZQdYyoEBRc9SV8eIcISTb8R5VYZqXrqxyhkfr1vN2srRI2raRNT99yFOCaRxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4ouZD+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4ouZD+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBA1C433F1;
	Tue, 27 Feb 2024 14:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043577;
	bh=GxBJax4VLy6D9jQ4iQjQCiF2fX/pATUMbiN0m4bCitg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4ouZD+odfPTr9GtBZt+I7Hl1NlqRHvLedfGjDWz5hWKyex6V2zwC9QdDiDF6KfI9
	 dNA3Kosl++/npI/HAv4Bc+74KOvJMtfAh9D+72iNUsYCZfsedWv/QvcvAyZFt3hTB1
	 A9g28Ze/6qkq5hIbJNhEuBRcvKjJzgQUaxrwIXMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	David Howells <dhowells@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/195] afs: Increase buffer size in afs_update_volume_status()
Date: Tue, 27 Feb 2024 14:26:59 +0100
Message-ID: <20240227131615.633280383@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 6ea38e2aeb72349cad50e38899b0ba6fbcb2af3d ]

The max length of volume->vid value is 20 characters.
So increase idbuf[] size up to 24 to avoid overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[DH: Actually, it's 20 + NUL, so increase it to 24 and use snprintf()]

Fixes: d2ddc776a458 ("afs: Overhaul volume and server record caching and fileserver rotation")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20240211150442.3416-1-d.dulov@aladdin.ru/ # v1
Link: https://lore.kernel.org/r/20240212083347.10742-1-d.dulov@aladdin.ru/ # v2
Link: https://lore.kernel.org/r/20240219143906.138346-3-dhowells@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/volume.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/volume.c b/fs/afs/volume.c
index 1c9144e3e83ac..a146d70efa650 100644
--- a/fs/afs/volume.c
+++ b/fs/afs/volume.c
@@ -341,7 +341,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 {
 	struct afs_server_list *new, *old, *discard;
 	struct afs_vldb_entry *vldb;
-	char idbuf[16];
+	char idbuf[24];
 	int ret, idsz;
 
 	_enter("");
@@ -349,7 +349,7 @@ static int afs_update_volume_status(struct afs_volume *volume, struct key *key)
 	/* We look up an ID by passing it as a decimal string in the
 	 * operation's name parameter.
 	 */
-	idsz = sprintf(idbuf, "%llu", volume->vid);
+	idsz = snprintf(idbuf, sizeof(idbuf), "%llu", volume->vid);
 
 	vldb = afs_vl_lookup_vldb(volume->cell, key, idbuf, idsz);
 	if (IS_ERR(vldb)) {
-- 
2.43.0



