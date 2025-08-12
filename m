Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9542FDC59;
	Tue, 12 Aug 2025 18:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024833; cv=none; b=BVNBZIUyv5amI51Uj+e5c3JSX4Y8TL1ProkJdMFMxMjrx7RUFomvC9buiQoR/wWrm6ul8iGcUUU/S38SvykHElHRIqCKUH+Av80vfCswJ1htmqBGxEEB0b04NbcWGGUztU6M9aK4eW4Rynxksw3RYYE/Au5k9/qvXkdKZe4OLXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024833; c=relaxed/simple;
	bh=BZGU40D7SHoHTb4txoZFEGkVs9xq4oFENEChxqbVHso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A36tdaq7IdvhzrKbcI/9mJNv6UC6/iZfNHivVClnSNUJ3FkL6bAu73hsh0gVIvJxgDtchNDB8Ed5fDaLMcRf9OAgHgQz2qkJ84xcmo9ZWwuYkvs4K5HFgkBCh3MnNMpAsBeq1iOfEe5/Kz41T6lzCWceHodoOX+YiDBIGgiGbhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4BC2+ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4BC2+ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5EAC4CEF0;
	Tue, 12 Aug 2025 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024833;
	bh=BZGU40D7SHoHTb4txoZFEGkVs9xq4oFENEChxqbVHso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4BC2+aexn8h9fgxymsCLAI6zogR/JV5ck7k+KaWz/YHOw3mZcqBJ3mBKGNS6X3gK
	 +E+J3sf/7mCsZaqMWlqdh0V3oeEjcRFbAxAR9KdCOwo0PDh1QqWBxjAJjijanVVNmG
	 70iw314mfud/S3MFrXRRs28cluubmOs/hTfE0KFU=
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
Subject: [PATCH 6.16 457/627] scripts: gdb: move MNT_* constants to gdb-parsed
Date: Tue, 12 Aug 2025 19:32:32 +0200
Message-ID: <20250812173438.431054863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



