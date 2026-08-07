Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747131A681E;
	Fri,  7 Aug 2026 15:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116514; cv=none; b=GPCoBgVlNU4R1xh3juZXgYd8PO4F3WJiZw6sYB07RJKq/WYqm9FYBl5UXgenEC+WqKmOMslcLasgW4R7KnW0dlXP+zQELkGlVvxb+gKkc/trfQYqpXhkq6SaYJ+gF47Q55FghvnDxyskYcMwGxqKh9Ua8ni2yXnbgUOcBgDElSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116514; c=relaxed/simple;
	bh=B7mVCkqwnWuDBDwEFhKKqOGBeEIM+d1N01v38q0mOVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bISjFe/+29majotPKx12AazUWQBqFbWLY9JRGQI/4CVf3xkdzIlXgXZ1zOUBAgis+fTB2rwJWypVMwuYDBLi2fsqJqu6LBhvLgMqd8OHwtBDnCpnBB+Aji8312veqZoxn3Abg/MZv+T3kXdRu0Wo8nUjoVuLo+pG/7YmW2Q8gAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoe263xO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoe263xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9CE1F000E9;
	Fri,  7 Aug 2026 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116513;
	bh=3c6iGWzRfCskJg/JNJaiPq43if9Rp+/S1Qv+MjYgAKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hoe263xOvr7kKH2ugmXeRwQBaD4vO0MfmEX8gzGAGJIhP70xIVhVAu48MNRCV34ic
	 8w9X3GfFRAVY6wMzsWtOrxDZ2zLaN868eFi1DqW8Ob5HuHWkYCmEkTnUbMWi5OsAZD
	 pYPR7CWEHbpGfUh/SJRpNfFr86rhC1BxZGg84RrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Scheiner <frank.scheiner@web.de>
Subject: [PATCH 6.6 213/261] Revert "ia64: Make acpi_cpufreq_cpu_exit return void"
Date: Fri,  7 Aug 2026 16:39:30 +0200
Message-ID: <20260807143419.962113448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Scheiner <frank.scheiner@web.de>

Commit b4b1ddc9dfe9 ("cpufreq: Make cpufreq_driver->exit() return
void") was part of v6.6.145-rc1. But as it was derived from a
later Linux version w/o support for ia64 it didn't touch all
relevant parts in linux-6.6.y. Which now required an extra fix to
build correctly for ia64. But b4b1ddc9dfe9 was then not part of
the release v6.6.145. So the extra fix can go now, too.

This reverts commit bb51b626b5a8ef349b11876572540f19ad4d5030.

Signed-off-by: Frank Scheiner <frank.scheiner@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/ia64-acpi-cpufreq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -302,7 +302,7 @@ acpi_cpufreq_cpu_init (
 }
 
 
-static void
+static int
 acpi_cpufreq_cpu_exit (
 	struct cpufreq_policy   *policy)
 {
@@ -316,6 +316,8 @@ acpi_cpufreq_cpu_exit (
 		kfree(policy->freq_table);
 		kfree(data);
 	}
+
+	return (0);
 }
 
 


