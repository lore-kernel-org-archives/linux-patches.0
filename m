Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D0E264FA2;
	Tue, 25 Mar 2025 12:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905557; cv=none; b=pw3pQ2W5WtIeu8TBh5UN/tMHx3MgnJIGJUqQpqZhAPli7bzvMv5D6HuHDHIG6ZxcrldDmUasM71wZbkhHa7rIIESGOTRVFs2Lv+v6y+fC3rDZxr+HP4ca1/hNg6ze4GGmOi8oQUTl6DIY6Khkmi6OUZ9ur9JDtCIlewnHKiKt4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905557; c=relaxed/simple;
	bh=N9g1xH6bNGDTlHu4Erhcz0y+Vchsabu5UbAB3PeqWlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o47Qdi9Tesi7b7mUZ9XwRif2/aDa8V9PfUTA0iC1NnJ7x5WFE6Sl/df9eiCYozIL5/N39v+1v/IvdB0NGhKs11309m3c3FDC7KIuEEP+U1o8CtwYeCT8wqVdcTLB38MQfiFGzLNk2Qb/9d+XwxhkL7n2HAKA2IA74zmZb86am6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E28daaEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E28daaEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB617C4CEE4;
	Tue, 25 Mar 2025 12:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905556;
	bh=N9g1xH6bNGDTlHu4Erhcz0y+Vchsabu5UbAB3PeqWlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E28daaEuc41VldvCSQZMCJmr6rxcoxvwm7uuvWwfq87pWRPXSgVsBEwaWbMJgWmyL
	 tCRB6m0TeFh31WcAo7Wn9uqmkv0oK0PklIATbrzwhYEKB+jEQCUmauAzaGJLHeFNof
	 Jnq36t/hp+RoeSmmQewjd6K5t68+Emzqm/fWqzCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gannon Kolding <gannon.kolding@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/198] ACPI: resource: IRQ override for Eluktronics MECH-17
Date: Tue, 25 Mar 2025 08:19:59 -0400
Message-ID: <20250325122157.613315799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gannon Kolding <gannon.kolding@gmail.com>

[ Upstream commit 607ab6f85f4194b644ea95ac5fe660ef575db3b4 ]

The Eluktronics MECH-17 (GM7RG7N) needs IRQ overriding for the
keyboard to work.

Adding a DMI_MATCH entry for this laptop model makes the internal
keyboard function normally.

Signed-off-by: Gannon Kolding <gannon.kolding@gmail.com>
Link: https://patch.msgid.link/20250127093902.328361-1-gannon.kolding@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 34cb7894e54ee..d4fb1436f9f57 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -553,6 +553,12 @@ static const struct dmi_system_id maingear_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "MECH-17"),
+		},
+	},
 	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
-- 
2.39.5



