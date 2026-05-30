Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06D2263F44;
	Sat, 30 May 2026 17:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161605; cv=none; b=C3l9VDx/4BkJch+IqtodI/MaqYA5qedNRyy0ffsnGYIQ9pi/Zqi+DGFRj2WQWSSZLwjvmqaUb3FI2qeiQC8IhTy8aYYgHB0BJz0h5IEN/jOwQIvmALO3tHKyqBPuFJD1cF2NYet0JrtlHP6RR6zgtm46nF/CTJTLpxG0mzJSnzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161605; c=relaxed/simple;
	bh=bqUwW4/BjJ2uq/DdmirhKjbneFjGeWFRKcSmQC4HibQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uU4pHqSbGvVvTc1NzA/Q31p3PgI+zNAFRrJzJ4TaNTXlwpCm9NtwjdmrgIKIXBWgsYVF95qefTiof7jyjA6zsfugF4sEjHcDA3x1JuZaJoORLLf+qxcgHyVL23Diq95IUJstX7abwSNtcLFeLO3lR4ilfaRtNBMrzrdu5rWeQEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWfWyJpa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWfWyJpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418981F00893;
	Sat, 30 May 2026 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161604;
	bh=Wu6OtE4pi5XYuIWYhlVCqJ7SxfWt6lD5JYMaMtPXPRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWfWyJpaSqccwLvv+z7hanOIh3ZeF3r7WJL2YrGRgXc9CJkQq12Cg9B69vilCyfwY
	 9J0QvYyZ/I3YD7NnmiH60FIpQEsDW+ph7wfUs47KbLM4bRKRgOg5WWKOfK+N6PNn0f
	 NNpbMTifVnbnivQugcClS3z7lSgN85M7vU4BVXL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 665/969] lib/hexdump: print_hex_dump_bytes() calls print_hex_dump_debug()
Date: Sat, 30 May 2026 18:03:09 +0200
Message-ID: <20260530160318.846804470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 36776b7f8a8955b4e75b5d490a75fee0c7a2a7ef ]

print_hex_dump_bytes() claims to be a simple wrapper around
print_hex_dump(), but it actally calls print_hex_dump_debug(), which
means no output is printed if (dynamic) DEBUG is disabled.

Update the documentation to match the implementation.

Fixes: 091cb0994edd20d6 ("lib/hexdump: make print_hex_dump_bytes() a nop on !DEBUG builds")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/3d5c3069fd9102ecaf81d044b750cd613eb72a08.1774970392.git.geert+renesas@glider.be
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/printk.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index b1a12916f0361..90f991cb2a5c9 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -748,7 +748,8 @@ static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
 #endif
 
 /**
- * print_hex_dump_bytes - shorthand form of print_hex_dump() with default params
+ * print_hex_dump_bytes - shorthand form of print_hex_dump_debug() with default
+ *                        params
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
@@ -756,7 +757,7 @@ static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  *
- * Calls print_hex_dump(), with log level of KERN_DEBUG,
+ * Calls print_hex_dump_debug(), with log level of KERN_DEBUG,
  * rowsize of 16, groupsize of 1, and ASCII output included.
  */
 #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
-- 
2.53.0



