Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D8718DF80;
	Tue, 11 Nov 2025 01:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825522; cv=none; b=dNJIqP63DmPItPMwSzc1afGyfFYhf1aXeID8aGZVVUd3qdC64BvHU02BZylpubcmmj0PweeT9xwGYva5KW1hhX7Rc9Afvurs/DsoF9/pHrz53/gegghudlKe9NiecQXe7kjHF+OtPvkV1BPO5vBZ7VhZUA+9HEOqYbqx3LCuD+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825522; c=relaxed/simple;
	bh=Hse+jJk7DQ4nKfqx/Uo1SuN0r5eEa3Hi80B4fISffvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2WDE5xkQI4Wfy0YQy73mpVgJRpAVnOclRrovUc6IVY9YDomtHMULUF5Ug0Yndu7Kn0IvsnmusmisQKTD7WSZSNjVWSHVuhM/vXV/CO0Z/gz1z+aGH1RrB/ge3knK2N67+mW3AfvdOncFpbFpr1k2WUSx2AlPITkXRi4zYJDrRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNjVs5Fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNjVs5Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB172C4CEF5;
	Tue, 11 Nov 2025 01:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825522;
	bh=Hse+jJk7DQ4nKfqx/Uo1SuN0r5eEa3Hi80B4fISffvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNjVs5Fb0yFQ3GeogJumFJoqQomfprRi9B+hhHEb4WmKvP39jS13rbXg/aXC3SIR3
	 qJWMrDjYUUUQ8aPZyQZVw8sbgoOD7JqpC/p3sz36CxWepeDjD1mcFtdSFkd2OhISHF
	 MQu+9FMK9czw/sioUoNj3aBLsAhdqzm0xMuGN6bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	David Gow <davidgow@google.com>
Subject: [PATCH 6.17 837/849] kunit: Extend kconfig help text for KUNIT_UML_PCI
Date: Tue, 11 Nov 2025 09:46:47 +0900
Message-ID: <20251111004556.661878485@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 285cae57a51664cc94e85de0ff994f9965b3aca8 upstream.

Checkpatch.pl expects at least 4 lines of help text.

Extend the help text to make checkpatch.pl happy.

Link: https://lore.kernel.org/r/20250916-kunit-pci-kconfig-v1-1-6d1369f06f2a@linutronix.de
Fixes: 031cdd3bc3f3 ("kunit: Enable PCI on UML without triggering WARN()")
Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/lkml/3dc95227-2be9-48a0-bdea-3f283d9b2a38@linuxfoundation.org/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kunit/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/kunit/Kconfig b/lib/kunit/Kconfig
index 1823539e96da..7a6af361d2fc 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -112,5 +112,9 @@ config KUNIT_UML_PCI
 	select UML_PCI
 	help
 	  Enables the PCI subsystem on UML for use by KUnit tests.
+	  Some KUnit tests require the PCI core which is not enabled by
+	  default on UML.
+
+	  If unsure, say N.
 
 endif # KUNIT
-- 
2.51.2



