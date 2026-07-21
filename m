Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A0C404BE9;
	Tue, 21 Jul 2026 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654845; cv=none; b=sCKYEl5RNKPn29w6jeabwqaiQHGiZo8KYjobbNyD+IzNEAW/4wb6UwrGltdmClJ8387VMPZDnlas7VuztcM/2qNbX+VsLuM+nYn2Gj+beqJX2KMXVmtYa4Ox4Ip9yox60DDhGf5KnHYF3YZYA4QEEPEjU9F9vkIAJZAR+U4wm4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654845; c=relaxed/simple;
	bh=zrj1spPutFlBauGQ9Uo6W8QRMsBQGitLqMt7VzC43dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLLC5e4NpGFeBxQNL297KGs7Sx3DBXDBegdA9B7k5vLNYJv6pgNkiszBlI5IgqdHIBgti/Yi68kS6CWTUy+y/1fkNdFnLFSqWL9Zu2Ao4z16VMJMdEMh3My3t45Jcmn8D0fWekC7B5ikN5DySImmWfo1SrdAwvjC8nc1DgWJuQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbD4/EY8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbD4/EY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AC81F00A3A;
	Tue, 21 Jul 2026 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654844;
	bh=Pl+vcJVLLRZPwWC1HwODVudXvjp93pbYQ5wRcRYskvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AbD4/EY87BZRhKZ+/VSqLpAgRsGoUX3oXqHo8mWIri0WBYstznlqeFEnyFZ5CdE0u
	 d6JAJos2lTrABG9lddsqQlMxbxdVo2qDkOQIUmBYyhjRwwxNXxs8quVTmj16DPFazO
	 kNg8NKFAzCYV5ZmYDom9u2RP8WHUFvYgGgbSCar8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1860/2077] dm-verity: increase sprintf buffer size
Date: Tue, 21 Jul 2026 17:25:33 +0200
Message-ID: <20260721152636.605366183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 88dd117c92a142253fb7a17e791773902b3babc6 upstream.

The prefix "DM_VERITY_ERR_BLOCK_NR" is 22 chars. Add '=', one digit for
type, ',', up to 20 digits for a u64 block number, and a NUL terminator:
that's 46 bytes. The buffer is 42 bytes. For block numbers >= 16 decimal
digits (devices larger than ~16 EB with 4K blocks), snprintf silently
truncates the uevent environment variable.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 65ff5b7ddf05 ("dm verity: add error handling modes for corrupted blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -26,7 +26,7 @@
 
 #define DM_MSG_PREFIX			"verity"
 
-#define DM_VERITY_ENV_LENGTH		42
+#define DM_VERITY_ENV_LENGTH		46
 #define DM_VERITY_ENV_VAR_NAME		"DM_VERITY_ERR_BLOCK_NR"
 
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144


