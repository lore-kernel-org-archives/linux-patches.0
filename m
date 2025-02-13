Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1151C23A990;
	Thu, 13 Feb 2025 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457394; cv=none; b=U6fwwT7dCn2/CCfX+EfBJsBiaqnISVT4IBcjejqGsmo1cSoErncsVEh673BewXOsE098AsN7y0e1o0Ad0hTOWDP7MMkjp3gBP1v5GWaR8aVCsnA/dxSrMswjC6VH0lhTs84+obkEaBywLTwRipj2JCxZWhTwjYSVHMgkd/BWzy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457394; c=relaxed/simple;
	bh=OMhXarR19030jFWxWFeXxU/3Q7yEiXwJuZ3Ou4fcYIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OAhfp5F8q7tU7W/oUSEKqkyCIQGqPyxXsPOhZ6s9PrcnBfWmPAYsPrS5qUItuG+0m+VCEo7942yi0sccconTizKUtJZlk2C0OpHmjMswNIj29ijc85mdVG1l5BH5YGECkIg1gR+5uc8MCyae+LzzP6/VyzEjzB22ak1K84XfCAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtpUO0bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtpUO0bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B9FC4CEE2;
	Thu, 13 Feb 2025 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457393;
	bh=OMhXarR19030jFWxWFeXxU/3Q7yEiXwJuZ3Ou4fcYIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtpUO0bn1gM+ozS+vcqUn1HnQpvI+naxKrFKpRNa9uYZl3NwPnbzMCKtwaNFmwfj6
	 +0XxjFrgO7vkFRh2Bi0lOb3qyaYmojiEfc372ylfj4tqWYL/GMLqS8ytB0o0C00tvs
	 uu1/faFNCgLTmjEm0/9S8XT6CnFZk3/Bt3H2Wsvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>
Subject: [PATCH 6.12 098/422] platform/x86: serdev_helpers: Check for serial_ctrl_uid == NULL
Date: Thu, 13 Feb 2025 15:24:07 +0100
Message-ID: <20250213142440.337593941@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 478b00a623d6c8ae23a1be7bcc96cb5497045cef upstream.

dell_uart_bl_pdev_probe() calls get_serdev_controller() with the
serial_ctrl_uid parameter set to NULL.

In case of errors this NULL parameter then gets passed to pr_err()
as argument matching a "%s" conversion specification. This leads to
compiler warnings when building with "make W=1".

Check serial_ctrl_uid before passing it to pr_err() to avoid these.

Fixes: dc5afd720f84 ("platform/x86: Add new get_serdev_controller() helper")
Cc: stable@vger.kernel.org
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204204227.95757-4-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/serdev_helpers.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/serdev_helpers.h
+++ b/drivers/platform/x86/serdev_helpers.h
@@ -35,7 +35,7 @@ get_serdev_controller(const char *serial
 	ctrl_adev = acpi_dev_get_first_match_dev(serial_ctrl_hid, serial_ctrl_uid, -1);
 	if (!ctrl_adev) {
 		pr_err("error could not get %s/%s serial-ctrl adev\n",
-		       serial_ctrl_hid, serial_ctrl_uid);
+		       serial_ctrl_hid, serial_ctrl_uid ?: "*");
 		return ERR_PTR(-ENODEV);
 	}
 
@@ -43,7 +43,7 @@ get_serdev_controller(const char *serial
 	ctrl_dev = get_device(acpi_get_first_physical_node(ctrl_adev));
 	if (!ctrl_dev) {
 		pr_err("error could not get %s/%s serial-ctrl physical node\n",
-		       serial_ctrl_hid, serial_ctrl_uid);
+		       serial_ctrl_hid, serial_ctrl_uid ?: "*");
 		ctrl_dev = ERR_PTR(-ENODEV);
 		goto put_ctrl_adev;
 	}


