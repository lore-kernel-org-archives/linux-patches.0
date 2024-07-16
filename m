Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047E71DDE9;
	Tue, 16 Jul 2024 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145782; cv=none; b=MMZR+zfeE6weUlxh3wcQW/eu0lAorYTa1fGpvoSXEjgEE9Ll0mJe6lAm0B1sXJ7uW7hcpaIC3k6Dr7cR3kL6ved5IYiGL2FhHagn/EOcVZyZ9jlPlZRCaO5IL1j4/QDD58iKdPCXEY/K+jt3S991AX3/Fv2WnuEGZlH2CThMVsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145782; c=relaxed/simple;
	bh=6Fx0Ns548mFqBQ05AhGgdaUteFi92kANHAxiXXPlSh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvPpkFafUooZSdBj8eL2aG+O7cHOkAsdzTetPDcx+jw7fYaiDqI+fmQe0xk6Ty50S6fJG0Lute6B+APXBT8S/amdHRSHSKdFsazg4w+UUhb98Z0Jbh5zEeZOvIUp7D3r4AJ72nKAM4jXzDjfuTV76M+En7msR42yDE59r8ueXaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7caIhAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7caIhAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9C1C116B1;
	Tue, 16 Jul 2024 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145781;
	bh=6Fx0Ns548mFqBQ05AhGgdaUteFi92kANHAxiXXPlSh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7caIhADbN7gNJF4V0N29X83YCZXhgZEZAEoTHtIh84xxtf8y9P5mCPHjKsS8vjtG
	 1tLQ3zAh4l2lDVVEfwAVeoJXnIq+qPxzUIAAtjY1pD9an1VclwyytCZ+HWZfxP1oBK
	 +rqxtT1ChIJmN1lkgbJezYMQ0cNoblRPAgdQW4zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 082/121] platform/x86: toshiba_acpi: Fix array out-of-bounds access
Date: Tue, 16 Jul 2024 17:32:24 +0200
Message-ID: <20240716152754.483414511@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Armin Wolf <W_Armin@gmx.de>

commit b6e02c6b0377d4339986e07aeb696c632cd392aa upstream.

In order to use toshiba_dmi_quirks[] together with the standard DMI
matching functions, it must be terminated by a empty entry.

Since this entry is missing, an array out-of-bounds access occurs
every time the quirk list is processed.

Fix this by adding the terminating empty entry.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202407091536.8b116b3d-lkp@intel.com
Fixes: 3cb1f40dfdc3 ("drivers/platform: toshiba_acpi: Call HCI_PANEL_POWER_ON on resume on some models")
Cc: stable@vger.kernel.org
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20240709143851.10097-1-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/toshiba_acpi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -3303,6 +3303,7 @@ static const struct dmi_system_id toshib
 		},
 	 .driver_data = (void *)(QUIRK_TURN_ON_PANEL_ON_RESUME | QUIRK_HCI_HOTKEY_QUICKSTART),
 	},
+	{ }
 };
 
 static int toshiba_acpi_add(struct acpi_device *acpi_dev)


