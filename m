Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065561;
	b=JgdcmVKfgOLqcNsFVsiO0WThxp8+KolMOcpcQoeSZErdiNSvNgxDjVO+O/xi45EmbpLE
	 BWk+IjoLjTNpUfRMKGYVz0jhw8yHiipp5WHg9+pPMLMEGoFsVitVpsNPPqqNaC0jRg8Z+
	 dUrJBBhl6KhyezD1O3nOCtlMtHdTD4VvxQ35vv83uako0fUqzVNDYCS//KboB4+GkwDvz
	 atMp9oAqWZfpE8cmNN36/L6P5Sc5qdzsJfz96Twv76ugJV/Y6WfD8eO/ETXASwMo2PTzu
	 9I0OSrrIFKE57x6b3nIkJNWIJ5PRuD/R627Ya9Ny7YIpF8Pb521iCNgLekvqcyUjzAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=I9VO1iIE7b+fYssz9EQcv6jrMz6yf4urN6G1UFJmkFo=;
	b=3M3UGbvgFdpT2oQq9i6hQFVOVa67jzBPEOpNoX+zUjPnMcnvMnJA/qwf3HBDUIKbIerZ
	 aLZxSkFt2Cr45Gv2GWaP1HF2PNOf6eVNhLuZEBREjN6eTbU50GTexLdR34WNW12QJPOmU
	 ukvR75/JyXvkbRNMZIu1IsZLDQYWNOR76lvAZ+K56OB18sMW4ZkNOmE0X9+v6Q4t2zKCY
	 58GytloxzRxLVfciUl4Mz86giA7NNOUO9T4pm0RTjGNgOoGrL1pmk1lMReiK78mfWkAzc
	 ST9BLjccPUT5fBPnh8jTyg2V4U/1DMxyPEts/sJqrGtGBgkwPn9UoSu1Zr2JhYUOVdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wR7Ze5a0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D637606A339;
	Sat,  7 Nov 2026 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wR7Ze5a0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47631F008A1;
	Sat,  7 Nov 2026 15:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065561;
	bh=I9VO1iIE7b+fYssz9EQcv6jrMz6yf4urN6G1UFJmkFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wR7Ze5a0WzEnf+AMupRHp1N1lbLxJin8R2is6AUccNdL4aU/BpgbTl+0t9HfJYiHD
	 oxWu7AqsqCsc2tkVIkxvn9Aeadxc5UzedVIzgBbKYcOF33sam3tyvWAOSvxsbNIY/r
	 w2mvAhOZgPJD6c73TW7BmJRhNUlLkYkreEmVwBRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1230/1257] userns: dont drop the exec securebits
Date: Sat,  7 Nov 2026 08:58:46 -0500
Message-ID: <20261107135013.315055847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit bf5ba73c9bdd5e872eb35e801e429a3b526f8f04 ]

SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE tell script
interpreters to only run what AT_EXECVE_CHECK allows and to refuse
interactive input. A service manager sets them together with their lock
bits so that nothing below it can turn them off again.

But set_cred_user_ns() resets all securebits to SECUREBITS_DEFAULT. So
any task that can create a user namespace sheds the locked exec bits
with a single unshare(CLONE_NEWUSER) and joining one with setns() does
the same. The lock is pointless if anyone who may create a user
namespace can drop it, and that is pretty much everyone.

Resetting the other bits is fine. They are about how capabilities are
computed and a new user namespace starts out with a full set of
capabilities anyway. The exec bits grant nothing though. They are
restrictions a task placed on itself, just like no_new_privs which a
user namespace doesn't touch either. So keep them and their locks.

Reproducer:

  // SPDX-License-Identifier: GPL-2.0
  /* Lock the exec securebits, then create a user namespace and look at them again. */
  #define _GNU_SOURCE
  #include <sched.h>
  #include <stdio.h>
  #include <sys/prctl.h>

  #define SECBIT_EXEC_RESTRICT_FILE		(1 << 8)
  #define SECBIT_EXEC_RESTRICT_FILE_LOCKED	(1 << 9)
  #define SECBIT_EXEC_DENY_INTERACTIVE		(1 << 10)
  #define SECBIT_EXEC_DENY_INTERACTIVE_LOCKED	(1 << 11)

  int main(void)
  {
  	int bits = SECBIT_EXEC_RESTRICT_FILE | SECBIT_EXEC_RESTRICT_FILE_LOCKED |
  		   SECBIT_EXEC_DENY_INTERACTIVE | SECBIT_EXEC_DENY_INTERACTIVE_LOCKED;

  	if (prctl(PR_SET_SECUREBITS, bits, 0, 0, 0)) {
  		perror("PR_SET_SECUREBITS");
  		return 1;
  	}
  	printf("before: 0x%x\n", prctl(PR_GET_SECUREBITS, 0, 0, 0, 0));
  	printf("clear locked bits: %s\n", prctl(PR_SET_SECUREBITS, 0, 0, 0, 0) ? "refused" : "ALLOWED");

  	if (unshare(CLONE_NEWUSER)) {
  		perror("unshare(CLONE_NEWUSER)");
  		return 1;
  	}
  	printf("after unshare(CLONE_NEWUSER): 0x%x\n", prctl(PR_GET_SECUREBITS, 0, 0, 0, 0));
  	return 0;
  }

On v7.1 this prints "before: 0xf00", "clear locked bits: refused" and
"after unshare(CLONE_NEWUSER): 0x0". With this patch the last line
reads 0xf00 as well.

Fixes: a0623b2a1d59 ("security: Add EXEC_RESTRICT_FILE and EXEC_DENY_INTERACTIVE securebits")
Cc: stable@vger.kernel.org # v6.14+
Link: https://patch.msgid.link/20261026-work-securebits-userns-v1-1-b35473fa1a34@kernel.org
Reviewed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/userspace-api/check_exec.rst | 4 ++++
 kernel/user_namespace.c                    | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/userspace-api/check_exec.rst b/Documentation/userspace-api/check_exec.rst
index 05dfe3b56f711..0904810e1d8d9 100644
--- a/Documentation/userspace-api/check_exec.rst
+++ b/Documentation/userspace-api/check_exec.rst
@@ -99,6 +99,10 @@ This secure bit may be set by user session managers, service managers,
 container runtimes, sandboxer tools...  Except for test environments, the
 related ``SECBIT_EXEC_DENY_INTERACTIVE_LOCKED`` bit should also be set.
 
+Both secure bits and their locks are inherited across :manpage:`fork(2)` and
+:manpage:`execve(2)`, and they are kept when a task creates or joins a user
+namespace.
+
 Here is the expected behavior for a script interpreter according to combination
 of any exec securebits:
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 0bed462e9b2a2..af06883dff0bd 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -45,8 +45,11 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
 {
 	/* Start with the same capabilities as init but useless for doing
 	 * anything as the capabilities are bound to the new user namespace.
+	 * The exec securebits grant nothing, they are restrictions the task
+	 * placed on itself. Keep them and their locks.
 	 */
-	cred->securebits = SECUREBITS_DEFAULT;
+	cred->securebits = SECUREBITS_DEFAULT |
+		(cred->securebits & (SECURE_ALL_UNPRIVILEGED | SECURE_ALL_UNPRIVILEGED << 1));
 	cred->cap_inheritable = CAP_EMPTY_SET;
 	cred->cap_permitted = CAP_FULL_SET;
 	cred->cap_effective = CAP_FULL_SET;
-- 
2.53.0



