Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B8A330B32;
	Thu, 28 May 2026 20:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001521; cv=none; b=QieVc3cjHbCkX1gec3v5PLHvcPc0N1U6eEuCjS96zlx8frgg0lWtHF+yXUs5M5fAPBhxa3CtsgV3tgfPYDKPpoJTOX+c8l6dICUYrHCjem5ftP2PJJajiGFB9jadQWcXz715iHVFCxkViUhWW2a1Xxr+9EUdz6Q0I1ixNdQQnAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001521; c=relaxed/simple;
	bh=nPO1vikQ118rR9BISOfaidrXiadSckj7uBCemKIvBp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rfh83GNJ7OjfOvMMPD7+lHGlqdTURyuozYT4or3pPIcJuC0HNWvtKCN1LFIKZ0stmMPxvjrDlhtIgCF7BdC/W14oZg8O+w1XmsDDWTaaB2DiBwsLbcZusHNQqZyKu4eq5yLruvRLbK5B2hW8T5RjbBUhOjm7RYPYl/C2PU9HFVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQADOy8m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQADOy8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6AC1F000E9;
	Thu, 28 May 2026 20:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001520;
	bh=5uAbcmWW9rLXkUSy1ZUgRghgo0ltB5nA0N8yhJy/0Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQADOy8mBu3EXOgTuw8NaGrEQG0I1Glo7eOWwkOr6uUiQeXO4hDsgQhyoBKlfaTzz
	 9w9o9cMeqByyftX9JnMjfqXOlhhZVVEnYJd3WOFgU8R7w8tvXRNB6Yj4i+1V+wGqwn
	 IVgD9Vd0NFOvwz0DkPQRCxZDUiUIVdElscAfnafs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/186] platform/x86: adv_swbutton: Check ACPI_HANDLE() against NULL
Date: Thu, 28 May 2026 21:50:38 +0200
Message-ID: <20260528194933.223669945@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit e7a9a6ea40e352cd7977f6a8c80bdeadf65ad838 ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_HANDLE() check against NULL to the
platform/x86 adv_swbutton driver.

Fixes: 3d904005f686 ("platform/x86: add support for Advantech software defined button")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/5115425.31r3eYUQgx@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/adv_swbutton.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/adv_swbutton.c b/drivers/platform/x86/adv_swbutton.c
index 6b23ba78e028f..f7bc252650d5a 100644
--- a/drivers/platform/x86/adv_swbutton.c
+++ b/drivers/platform/x86/adv_swbutton.c
@@ -48,10 +48,14 @@ static int adv_swbutton_probe(struct platform_device *device)
 {
 	struct adv_swbutton *button;
 	struct input_dev *input;
-	acpi_handle handle = ACPI_HANDLE(&device->dev);
+	acpi_handle handle;
 	acpi_status status;
 	int error;
 
+	handle = ACPI_HANDLE(&device->dev);
+	if (!handle)
+		return -ENODEV;
+
 	button = devm_kzalloc(&device->dev, sizeof(*button), GFP_KERNEL);
 	if (!button)
 		return -ENOMEM;
-- 
2.53.0



