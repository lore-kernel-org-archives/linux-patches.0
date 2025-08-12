Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C91217F35;
	Tue, 12 Aug 2025 19:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026539; cv=none; b=Mrooi3jc4dsSOkPflSXX2pYZfm6IaRoAA5Fa9QcHYyNIKQ46ocV2T8abgPzqeUIfr91/WhPrHtrafddjY77Go0OYOO53DmqGxDyoJEKYTrtEx+8QYv4hW7C06jjAmMDoRwJkb5frNwDMPkbfw2q9yQiqiXR2oUPTJQ9SaKalBYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026539; c=relaxed/simple;
	bh=0O4hU/cGsAt+jNtUMDEixZa7kEMjxWT7t95RnyJu9+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkZzxKoP4G3BO6SZ38gom1wW9NdtrrHtyXxjqZEhvwdGiNsRDLYLwCjLuHaiCHh/6iSopAKU5DAfG9mkia3MlUrD2xLtKt1pgBVX5ugckaF/ZanAI8Wx+6AuGzOwzHy19AEfoGdXC+8Ne36dJ7Qe77FnjZ49MMrGOk5gtEY5xbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EjDKdw/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EjDKdw/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6693DC4CEF0;
	Tue, 12 Aug 2025 19:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026538;
	bh=0O4hU/cGsAt+jNtUMDEixZa7kEMjxWT7t95RnyJu9+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjDKdw/xL3c0tbDy47AzAdfW8wovWvXBTiOvmklwzzuEo8VEDwTJ/JeZnEhYp39ec
	 pHCJSgSMj+RPF+MnrPuqpOUjzXMEM8FQvjxr9hkKhcBgKQzZjH6olv8Gh4oeYW1gtk
	 WiVaxIbAJtyU200ljn44VTErZAat4RPcdAxeitQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 334/480] scripts: gdb: move MNT_* constants to gdb-parsed
Date: Tue, 12 Aug 2025 19:49:02 +0200
Message-ID: <20250812174411.218711449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 41a7f737685eed2700654720d3faaffdf0132135 ]

Since these are now no longer defines, but in an enum.

Link: https://lkml.kernel.org/r/20250618134629.25700-2-johannes@sipsolutions.net
Fixes: 101f2bbab541 ("fs: convert mount flags to enum")
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/constants.py.in | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/gdb/linux/constants.py.in b/scripts/gdb/linux/constants.py.in
index f795302ddfa8..c3886739a028 100644
--- a/scripts/gdb/linux/constants.py.in
+++ b/scripts/gdb/linux/constants.py.in
@@ -74,12 +74,12 @@ if IS_BUILTIN(CONFIG_MODULES):
     LX_GDBPARSED(MOD_RO_AFTER_INIT)
 
 /* linux/mount.h */
-LX_VALUE(MNT_NOSUID)
-LX_VALUE(MNT_NODEV)
-LX_VALUE(MNT_NOEXEC)
-LX_VALUE(MNT_NOATIME)
-LX_VALUE(MNT_NODIRATIME)
-LX_VALUE(MNT_RELATIME)
+LX_GDBPARSED(MNT_NOSUID)
+LX_GDBPARSED(MNT_NODEV)
+LX_GDBPARSED(MNT_NOEXEC)
+LX_GDBPARSED(MNT_NOATIME)
+LX_GDBPARSED(MNT_NODIRATIME)
+LX_GDBPARSED(MNT_RELATIME)
 
 /* linux/threads.h */
 LX_VALUE(NR_CPUS)
-- 
2.39.5



