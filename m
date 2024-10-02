Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E245F1CF5FB;
	Wed,  2 Oct 2024 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876919; cv=none; b=ilz61u78r5UZO4cmLsLzAH0Tbr5H13D8ZKxWQNJH6DVQHCX+c37uLfH6dGOy2D2L8p/8DmHIRjHZf3QXIWga9xY/Ju5GgUvpzA9RwgyT3IrPw2h9/nOmEFyufF70amAbTbLL/sfDeJqXpY+LjzTYfc7IYrBJqWcO0Cg+YGoljC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876919; c=relaxed/simple;
	bh=yF/IMAZDYwzcnaUt+ZKdfB1OF2Wei3eAL24a952FNGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eg6JtEbO+RvgqAwMkCpLmVsqGnzCDt+Yjqd/GeCEBsbFZA/tKZ9Pi3zJwyZyfU10kOqBUvcVu3OPVWhnus0lpw6JE0wYOzfqA530zISmzZmS2Kp/iBfUqxsj4CtGmOPDHc7PXMnHag2WfnhCytHdnA3l7dc4CmPntatQ6WCoiEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOp7s0qQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOp7s0qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62ACDC4CEC2;
	Wed,  2 Oct 2024 13:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876918;
	bh=yF/IMAZDYwzcnaUt+ZKdfB1OF2Wei3eAL24a952FNGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOp7s0qQe6eGtUkLkrlXk7IS1TP1HYoxiiK8k4OC8wFnRypLYTcxDC0KC4A+5f7aG
	 fxCyaw/5HtW3i/BDGg2SoYqysvTPnMKHBKezrEgXpZRl+mplKR5BIukTJn6GS3nKNP
	 nbNEgvRR31xVmVcXcbRZdSZ2eUBziY4rOsGwsYbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 605/695] ACPI: resource: Do IRQ override on MECHREV GM7XG0M
Date: Wed,  2 Oct 2024 15:00:03 +0200
Message-ID: <20241002125846.664040475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <me@linux.beauty>

commit b53f09ecd602d7b8b7da83b0890cbac500b6a9b9 upstream.

Listed device need the override for the keyboard to work.

Fixes: 9946e39fe8d0 ("ACPI: resource: skip IRQ override on AMD Zen platforms")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Li Chen <me@linux.beauty>
Link: https://patch.msgid.link/87y15e6n35.wl-me@linux.beauty
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -555,6 +555,12 @@ static const struct dmi_system_id irq1_l
  */
 static const struct dmi_system_id irq1_edge_low_force_override[] = {
 	{
+		/* MECHREV Jiaolong17KS Series GM7XG0M */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GM7XG0M"),
+		},
+	},
+	{
 		/* XMG APEX 17 (M23) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GMxBGxx"),


