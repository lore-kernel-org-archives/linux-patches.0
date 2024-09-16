Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABB92D047;
	Mon, 16 Sep 2024 11:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487994; cv=none; b=RAi/zuqWrx1lPNoYsatiehe2wkNQBFT8s3Qn6YjV4SETfVghwlYjk0XThvTDFjXxa4v1IvOBmiL6+59D/9984J2osynewM/hdNTAXb4A2Z+QNTakZL0+/gRMTLE66siMRtxCeR9DGSX/uCoEZJ1GEcRTJq2ucQtbQXa2dUI7ygw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487994; c=relaxed/simple;
	bh=D7+D3vv4e8W9nsV8RRxnzxPhD+lXHt/0dIL5GqKtDoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9cObqyf+iLVosOylsQ38tZFVLIBaOBSNhJBdJxLiVvgD4Z1dEnzPZ1y5bB2cNuf3TQ5sRgjIzBFnhuErexQ5lGtM1/1wgG5dnBSuAjoDHtZJKW7K91DHT6SOMy9JEPwarzbhEcQn5CFSl9yy+qSMgLMFW5oHlbZDSssX74mthU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0C0nqo8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0C0nqo8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CB3C4CEC4;
	Mon, 16 Sep 2024 11:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487994;
	bh=D7+D3vv4e8W9nsV8RRxnzxPhD+lXHt/0dIL5GqKtDoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0C0nqo8dHl8ZH/uQqqa6wVHmLXZC7ygEMc0No8ZBZatW1zKTLMkecNlRW10rzL/0B
	 Fc3xJ6vJIBZKC1ufOUwkiaVo8JLjbi1WSJ4ki+7yhR8a2fpPMUkR1AC0cXiNLJ+lui
	 XBTULRwYKJ5K+9r8PiSA8E4N9bhV+x/7erq/thC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Harmison <jharmison@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 22/63] platform/x86: panasonic-laptop: Allocate 1 entry extra in the sinf array
Date: Mon, 16 Sep 2024 13:44:01 +0200
Message-ID: <20240916114221.855489440@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

commit 33297cef3101d950cec0033a0dce0a2d2bd59999 upstream.

Some DSDT-s have an off-by-one bug where the SINF package count is
one higher than the SQTY reported value, allocate 1 entry extra.

Also make the SQTY <-> SINF package count mismatch error more verbose
to help debugging similar issues in the future.

This fixes the panasonic-laptop driver failing to probe() on some
devices with the following errors:

[    3.958887] SQTY reports bad SINF length SQTY: 37 SINF-pkg-count: 38
[    3.958892] Couldn't retrieve BIOS data
[    3.983685] Panasonic Laptop Support - With Macros: probe of MAT0019:00 failed with error -5

Fixes: 709ee531c153 ("panasonic-laptop: add Panasonic Let's Note laptop extras driver v0.94")
Cc: stable@vger.kernel.org
Tested-by: James Harmison <jharmison@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240909113227.254470-2-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/panasonic-laptop.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -337,7 +337,8 @@ static int acpi_pcc_retrieve_biosdata(st
 	}
 
 	if (pcc->num_sifr < hkey->package.count) {
-		pr_err("SQTY reports bad SINF length\n");
+		pr_err("SQTY reports bad SINF length SQTY: %lu SINF-pkg-count: %u\n",
+		       pcc->num_sifr, hkey->package.count);
 		status = AE_ERROR;
 		goto end;
 	}
@@ -994,6 +995,12 @@ static int acpi_pcc_hotkey_add(struct ac
 		return -ENODEV;
 	}
 
+	/*
+	 * Some DSDT-s have an off-by-one bug where the SINF package count is
+	 * one higher than the SQTY reported value, allocate 1 entry extra.
+	 */
+	num_sifr++;
+
 	pcc = kzalloc(sizeof(struct pcc_acpi), GFP_KERNEL);
 	if (!pcc) {
 		pr_err("Couldn't allocate mem for pcc");


