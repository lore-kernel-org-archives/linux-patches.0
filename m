Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863D31D90DB;
	Tue, 15 Oct 2024 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992142; cv=none; b=SwoVmMCR3F7o3/DbWegCrDZEWJ8UnWI3WefB+9pS8E7aOifVfs7IQsNZaDS3DLM23G/9D9KVIXyGChIZnqWW7Pp5MpJlLXsmfhWVrfcwJxTZPOseSZZTq6/RUTX6FpOQwd92DD570ZnQtTJR/6cuXesXOedvEOzxmEXEkJyOGdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992142; c=relaxed/simple;
	bh=LqcdnXvS78tJuJIQdQpoAr3pXfHJqUF1DqvREb7tnzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pjv+r3KBPVtF/vLX0GALoAXXIIlamtSTEjAm7mgnXoA9MNhHjaxHAZxmCyKh3my/X929uCXHPdU6TvIaU2ThLuNeyv81yWRmrQKdWzCN6zMy8DE1Ud9QmtfChXMFgO53TO+vZ3KpH1xLm7iSeRHBD+o6f8NwUamuBvxOhRQVTOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zk+g0Ojm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zk+g0Ojm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B9FC4CEC6;
	Tue, 15 Oct 2024 11:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992142;
	bh=LqcdnXvS78tJuJIQdQpoAr3pXfHJqUF1DqvREb7tnzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zk+g0OjmGf9Soc61ERz6piksfK7ROn1vHzz65xFac1VnVARxTHzEqxyGaEgjUIzBr
	 R2Wo5ivGCMx0MoCVtxOFo/Mh4Zv4EIXWgceQGFRRuwi/LNJRCxA/mZa/HSJP6wcHmc
	 yUmDE+WgUUjgu4Dqi0GkQ8UPpoO5jIgl8XgM0/Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Harmison <jharmison@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.15 030/691] platform/x86: panasonic-laptop: Allocate 1 entry extra in the sinf array
Date: Tue, 15 Oct 2024 13:19:38 +0200
Message-ID: <20241015112441.533373254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


