Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21193324B19;
	Mon, 27 Oct 2025 19:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592177; cv=none; b=bdiWkIYmOLf8mDxJsps6qQIUL1fiiM6eihfrmhDAwIB97ScDbE4usDBhci8FtSnFTCkvhDK3+Ya5GuQN9mq8MRD4AkyJ9P/1YOSAPbAqrTIDr9/xJeW3ijRGzQmgzgJlbwGNniu8UlMPI1KjnS1mAsRGu3kzxZk855kcNLzPqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592177; c=relaxed/simple;
	bh=rtH/JOvCAw40Gnd9t1M6VtSo+LiVQHB2PX9I6lWcpck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZv82xCehqXIdgcjLMFc3HFbxVhaRP+aBS4QU03Jw9swuTCUeeKXwKWfhQu53XZJ+NcRLRQA7AvG1GTAUConuCUhG4ZMXfQqrUpJ9xwiiK/8ijcuPz+nJ5RkE1oJccp3AL42h9AenTOu3keIzwOLxG5qrkBcZxr+rnjHotn1veY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itecbKJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itecbKJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60C6C4CEF1;
	Mon, 27 Oct 2025 19:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592177;
	bh=rtH/JOvCAw40Gnd9t1M6VtSo+LiVQHB2PX9I6lWcpck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itecbKJqThoJzLfz+b6HHiGKBM+ZiSyxL9QBSqgUsYmrLRow1UYvFP1dhFoQfcerp
	 XcvBwDNBoqrhq7D7eEJ+OQ4hj+fDPKo5zAe+6z6Z8CbiUZEcFM7A4C0fwOqJQE3RGh
	 FeAiOoPPREWLum1KlRoL/fbpdB8UEco195i5MWi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 6.1 023/157] Documentation: Remove bogus claim about del_timer_sync()
Date: Mon, 27 Oct 2025 19:34:44 +0100
Message-ID: <20251027183501.899001817@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b0b0aa5d858d4d2fe39a5e4486e0550e858108f6 ]

del_timer_sync() does not return the number of times it tried to delete the
timer which rearms itself. It's clearly documented:

 The function returns whether it has deactivated a pending timer or not.

This part of the documentation is from 2003 where del_timer_sync() really
returned the number of deletion attempts for unknown reasons. The code
was rewritten in 2005, but the documentation was not updated.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Link: https://lore.kernel.org/r/20221123201624.452282769@linutronix.de
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-hacking/locking.rst                    |    3 +--
 Documentation/translations/it_IT/kernel-hacking/locking.rst |    4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/Documentation/kernel-hacking/locking.rst
+++ b/Documentation/kernel-hacking/locking.rst
@@ -1006,8 +1006,7 @@ Another common problem is deleting timer
 calling add_timer() at the end of their timer function).
 Because this is a fairly common case which is prone to races, you should
 use del_timer_sync() (``include/linux/timer.h``) to
-handle this case. It returns the number of times the timer had to be
-deleted before we finally stopped it from adding itself back in.
+handle this case.
 
 Locking Speed
 =============
--- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
+++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
@@ -1027,9 +1027,7 @@ Un altro problema è l'eliminazione dei
 da soli (chiamando add_timer() alla fine della loro esecuzione).
 Dato che questo è un problema abbastanza comune con una propensione
 alle corse critiche, dovreste usare del_timer_sync()
-(``include/linux/timer.h``) per gestire questo caso. Questa ritorna il
-numero di volte che il temporizzatore è stato interrotto prima che
-fosse in grado di fermarlo senza che si riavviasse.
+(``include/linux/timer.h``) per gestire questo caso.
 
 Velocità della sincronizzazione
 ===============================


