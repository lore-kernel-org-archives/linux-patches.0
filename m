Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64D027453
	for <patches@lists.linux.dev>; Sun, 17 Aug 2025 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755450940; cv=pass; b=OOfCezBj/WWj8GVYKPOxOXxT6eTCL80JP/L1DlpDuYQMY6pRsuo7fW+dl8qouF7ttDCAEY/4dnrHmv38e7OwJXS/nyqwD1568a1OpvxQp7LpDh0SjNmrygCfSRbT8sWRHWP2mVcuwDQd7+ZtULsbVuvKymPwdyZd51dqHpMbM6w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755450940; c=relaxed/simple;
	bh=iBHwvalA/Mc1nPmfxvrfVnqvey64uHAHShpX6Lk8xYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Lq7TG6tTrQ3IPJiKBGn5T+ot3vJCiC9ZGsJZd3MEzgwYGmFYMSxKARIxXUaRkIKaFVcqdrLuxpwuWIx7yfH96OpNt9NxpGUcEd1NeoM2Rm8++WA8CrHsztawctClUK26fA+2zwTkmhEP+khZtomlzw2XCHKUBKnEEWvrymVgg4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=eurnLHsl; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="eurnLHsl"
ARC-Seal: i=1; a=rsa-sha256; t=1755450933; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=InnrDTU8ilDdMK2/KX0mj7fwnImtEtEr+N7a4ETuOBgare1yhgD5NQeAz8es9Yp9kTSr16OzL6R8CRclsOHu96waAKxqXQ//T0IQ2PdJ8TyBwRqMCCgFHaUxomI/upJW4qt9xSBabEZ3K3HbYXqVYPNbOsm3PwDfs+xD7NfSTLc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755450933; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=ViY095fg/kzvW7mbPbRB9wevfbtS7vvGCg+1E/G9ev4=; 
	b=AreCIv0b7zw2U2ecwKwBKyFC4hY6VGiIIihot50d1pi7teVOTNRiGHVIj/2Aah9og+lWwQXDAmLUf1Eg7TkBNLFUPMggg/0djcFb8KHXhDKp174QIJKhoe5l0vkFRsBL0D0HZQXDEQhQDY/BGhIicMLP6dvzu6LYVxw9I/CYAcI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755450933;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=ViY095fg/kzvW7mbPbRB9wevfbtS7vvGCg+1E/G9ev4=;
	b=eurnLHsl0z0cu4ijzYB1ofdCwCe8sQRwDGgr9dig9BXqzAs74CF+VNVuyiOAFOXa
	mk8/M7XonQ35IZgNS8iSV7vn1VMAc3Mt7ztFtSSbzRD0/qCz+X72/V+fk65SLGgdfpT
	kaY2ObOZLZdvRpnoQhDK0fdncrYYNZyN8VT/Q39I=
Received: by mx.zohomail.com with SMTPS id 1755450930270200.28498429674107;
	Sun, 17 Aug 2025 10:15:30 -0700 (PDT)
From: Askar Safin <safinaskar@zohomail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	cyphar@cyphar.com,
	Ian Kent <raven@themaw.net>
Cc: linux-fsdevel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	autofs mailing list <autofs@vger.kernel.org>,
	patches@lists.linux.dev
Subject: [PATCH 0/4] vfs: if RESOLVE_NO_XDEV passed to openat2, don't *trigger* automounts
Date: Sun, 17 Aug 2025 17:15:09 +0000
Message-ID: <20250817171513.259291-1-safinaskar@zohomail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr08011227cf344161cc8e36d43358c44f0000e446248a082fb86fa76641387b1e314a0f499e8c173e343bb1:zu08011227f65ae9751271c2df701fbc4b00002743f4b67102cf39e9a15adaff41a995eaed22a2990ccb6b0e:rf0801122c333a2d3d058be4b8b2a9fda50000d0443a7eb151880040e764fcb819b339a4a23844ed17b0e4565d64430f49:ZohoMail
X-ZohoMailClient: External

openat2 had a bug: if we pass RESOLVE_NO_XDEV, then openat2
doesn't traverse through automounts, but may still trigger them.
See this link for full bug report with reproducer:
https://lore.kernel.org/linux-fsdevel/20250817075252.4137628-1-safinaskar@zohomail.com/

This patchset fixes the bug.

RESOLVE_NO_XDEV logic hopefully becomes more clear:
now we immediately fail when we cross mountpoints.

I think this patchset should get to -fixes and stable trees.

I split everything to very small commits to make
everything as bisectable as possible.

Minimal testing was performed. I tested that my original
reproducer doesn't reproduce anymore. And I did boot-test
with localmodconfig in qemu

I'm not very attached to this patchset. I. e. I will not be offended
if someone else will submit different fix for this bug.

Askar Safin (4):
  vfs: fs/namei.c: move cross-device check to traverse_mounts
  vfs: fs/namei.c: remove LOOKUP_NO_XDEV check from handle_mounts
  vfs: fs/namei.c: move cross-device check to __traverse_mounts
  vfs: fs/namei.c: if RESOLVE_NO_XDEV passed to openat2, don't *trigger*
    automounts

 fs/namei.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

-- 
2.47.2

