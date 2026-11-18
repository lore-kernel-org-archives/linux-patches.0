Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031101;
	b=Fbdpj7Yx/Vmv67R4oxOHb0e1MMEAv4EmdiBTpuq75Mu908F8eN3OqchKChkQiBraiLPD
	 G1mvu94L4xNA6hNPyEv6Wbx17bnvVLBCtzqjTFyBh4jBlL82CoEeAUoUQD7upnH+SyGCO
	 cwxjuU+YYsKhq030UmZdxpFaCQyzvrMu1LsRO44SBb6k0WfFPX8bje/nZ7RiucnlJ6JFO
	 aEuAj6M/mckTMRGOfjTphdOCSz+gx57IgeVsOqJATbEoDWe0aWq4vWkQFlVAKt1tclR1e
	 mtgac/d3xNxLWZIeR7853zJF34j7/DcJCzppXTBPftbAgMBrJK23OHkpq6XyKHxnd+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/y4da/Nq/Qlt2B+nlpud1IaXAyH+408jXDrKzNIocPU=;
	b=a3WsPjgYfmJTk5ySTWmx4oVbcsfqS6sQ2Y3sPXPobKEdfHIpr1ICC8Z8fSTJ0uwDipEr
	 N1aiNsXkVe+egr3oAqZdCdki5O/YMdeLuRBRLNJscqsiNO+2OV5pyNrvNEVo1xjUYIvSh
	 PZZwT14445cj2P0fpq97ibaVN32sRi5Omt03JEtP2f7zvA7m9WoucHRxS+EYQalqEePF5
	 N71UCU3/02/A1KEqzwFIJOzqwmI2i2t5z+Dap6aNLthgH7QtJub9Ft+neM6jvcyJhq9xp
	 MMY6kF465uJ3VKtZbLNrD5KlkXr9AG29whlJR7iAe1IDo9yQMqIGZ+9ZalJALKOpnUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCu5fYfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB8A606A330;
	Wed, 18 Nov 2026 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCu5fYfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A45A1F000C4;
	Wed, 18 Nov 2026 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031101;
	bh=/y4da/Nq/Qlt2B+nlpud1IaXAyH+408jXDrKzNIocPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCu5fYfWiDUdObU2wezXRVwhD64ZI4ddCeRBfKEvZAHaLt6cDZBm87Eh37YeCX97P
	 5h2ohPo8CRB/WenyFMKNgbXhcS5AZBol0DmsrZG/1bsbmzR99B2UivC7Zl7hYgXuhq
	 uFUxnMTduegG0mq6WEWq/VWlJuyaL8OHMgDLxwkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0940/1756] init/main: fix off-by-one in argv_init cleanup
Date: Wed, 18 Nov 2026 15:51:07 +0100
Message-ID: <20261118150047.446570119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilson Felipe Pereira <wfelipe@google.com>

[ Upstream commit b82ed0e3a1dafe41577b095318a3ea6c0eec6f46 ]

Patch series "init: fix array boundary bugs in boot parameter parsing".

This series fixes two distinct boundary logic edge-case bugs in
`init/main.c` related to parsing boot command-line arguments and
environment variables.  Both bugs have been present since the early git
history (Linux-2.6.12-rc2).

1. The first patch fixes an off-by-one error in `init_setup()` where
   the final slot of the `argv_init` array was left uncleared. This
   allowed a stale kernel parameter to leak into the `init` process's
   user-space command line if exactly `MAX_INIT_ARGS` unknown
   parameters were passed.

2. The second patch fixes a false-positive kernel panic in
   `unknown_bootoption()`. If a user filled the environment variable
   array up to its exact limit (32) and then attempted to overwrite
   the final variable, the kernel would panic before evaluating
   whether it was a harmless duplicate.

Exact QEMU reproduction steps for both edge cases are documented inside
their respective commit descriptions.

This patch (of 2):

When cleaning up argv_init in init_setup() and rdinit_setup(), the loop
terminates one element early due to using '<' instead of '<='.  Since
argv_init is sized MAX_INIT_ARGS+2, index MAX_INIT_ARGS is a valid element
that should be cleared to NULL.

If exactly MAX_INIT_ARGS unknown arguments are passed before 'init=', the
uncleared argv_init[MAX_INIT_ARGS] can act as a ghost argument to
/sbin/init or cause a spurious kernel panic when later appended to.

To verify the argument leak, boot a VM into a shell with 32 unknown kernel
arguments, the init parameter, and 31 user arguments:

  STALE_ARGS=$(for i in {1..32}; do echo -n "stale$i "; done)
  USER_ARGS=$(for i in {1..31}; do echo -n "user$i "; done)
  qemu-system-x86_64 -kernel bzImage \
      -append "$STALE_ARGS init=/bin/sh $USER_ARGS"

Running `cat /proc/1/cmdline` inside the shell reveals that the 32nd
kernel argument ('stale32') incorrectly leaked into the init process's
command line.  This patch zeroes the final slot, cleanly terminating the
array.

Link: https://lore.kernel.org/20260818045357.4123784-1-wfelipe@google.com
Link: https://lore.kernel.org/20260818045357.4123784-2-wfelipe@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: ffdfc40976dd ("[PATCH] Add rdinit parameter to pick early userspace init")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index bad880340de43..92397b5a3a6e3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -570,7 +570,7 @@ static int __init init_setup(char *str)
 	 * the shell think it should execute a script with such name.
 	 * So we ignore all arguments entered _before_ init=... [MJ]
 	 */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
@@ -582,7 +582,7 @@ static int __init rdinit_setup(char *str)
 
 	ramdisk_execute_command = str;
 	/* See "auto" comment in init_setup */
-	for (i = 1; i < MAX_INIT_ARGS; i++)
+	for (i = 1; i <= MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
 	return 1;
 }
-- 
2.53.0



