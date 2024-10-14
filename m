Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E7814AA9;
	Mon, 14 Oct 2024 15:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919534; cv=none; b=bgfdA3u7xf88aLYZ4TI6NSAOf5s2Zk45yDkqPExxiKV0HERqrJ1sejPBgsp6TEQV/+f+CTVW47ys9H8YumhCpLWT0piOZ5fPH6LQnZmIQh0UdnhXXzqltCE4Tp9j6/3cv80z2+JJoOf2aOT5wjmSllAlWv/pE4JpM+qE1RXGxqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919534; c=relaxed/simple;
	bh=zhk6xaT90LbweuAYLR3GRoC/XmqIPTUPizTTnK6asl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDonlDrrNc6XhRDknqmznxCNsOw1sxfAxh+QmplOs8pztaWZlB5sAfGrfDs/kitIWqTvbeXUW0W7FIopiR4NL+0UwNlp7711/jv2Kimg8CjZ4BwOcW56cTMyxp5UmRAswjgQcDACjYNgZaP29OD1INI5yMRvzIG/zi5WwfF8Tvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0Jrust7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0Jrust7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C83DC4CEC3;
	Mon, 14 Oct 2024 15:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919533;
	bh=zhk6xaT90LbweuAYLR3GRoC/XmqIPTUPizTTnK6asl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0Jrust7hgmE1Dmz9GB+fVCbWJ8Rwsh56OHEn6ilHrex5Wu0sa/rQ+5XA9h6Ahs39
	 DbMbJhra0NxICmSmmWswN+0/3A2wcVGj2XCYtBOIRanJXVys7BcgdnXfhyFRjiBOs8
	 AiJrGNfbU9Yj55eSQe1ZXxrBEmKg17eVEAiZDlOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lamome Julien <julien.lamome@wanadoo.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 602/798] ACPI: resource: Add Asus Vivobook X1704VAP to irq1_level_low_skip_override[]
Date: Mon, 14 Oct 2024 16:19:16 +0200
Message-ID: <20241014141241.662355711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2f80ce0b78c340e332f04a5801dee5e4ac8cfaeb upstream.

Like other Asus Vivobook models the X1704VAP has its keybopard IRQ (1)
described as ActiveLow in the DSDT, which the kernel overrides to EdgeHigh
which breaks the keyboard.

Add the X1704VAP to the irq1_level_low_skip_override[] quirk table to fix
this.

Reported-by: Lamome Julien <julien.lamome@wanadoo.fr>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1078696
Closes: https://lore.kernel.org/all/1226760b-4699-4529-bf57-6423938157a3@wanadoo.fr/
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240927141606.66826-3-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -440,6 +440,13 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* Asus Vivobook X1704VAP */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "X1704VAP"),
+		},
+	},
+	{
 		.ident = "Asus ExpertBook B1402CBA",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


