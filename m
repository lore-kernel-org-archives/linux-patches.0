Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC711428E9;
	Thu, 13 Jun 2024 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279278; cv=none; b=eGMukPVNGAezFYhV218zJROYl961C2SJ5F47msyKtxKN346c2fi52wZ0KqvkrEW+sOkf9ovGRtgDjm4k3W1+2NnjIylb7K975KvyoYSkrrpkh5B3a1NFet1Mw0cmAuzdm79rxTUX+0L/HSS220rtaNH2fzoeH/ZYwhdnXEcxLFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279278; c=relaxed/simple;
	bh=VH5ZiWY8QJ7UAjyqVZ7zox3fXbyfTh8je01bOiaf6eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSs0e4HzSMbqs7g+Vag7II+VBk9lFShv8e64veeLnlsHDWQ7bKMAHzjffR4UaEcs+j1N+X8Y7jT80C6n4a11cHaTdRnzIZJRdm3XQXyOtux89pp9YfRVzqG7r3oUcZ96sX9aSY70E2ky7oIHNcvIidY42lKmDoWpmErtLC62SDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcBerGOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcBerGOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7968C2BBFC;
	Thu, 13 Jun 2024 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279278;
	bh=VH5ZiWY8QJ7UAjyqVZ7zox3fXbyfTh8je01bOiaf6eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcBerGOi4//axGWodxmRUQgWp2wGYuixfGqsdEn0VLwdk5elRtlqlhUvfOfcL1FYR
	 uWjiPXIw1+eAkBLNo5BWtrr7OJ597Xucrh6KGmjlmdbLSOQn7/+gqhA00baxfJfoCi
	 0qR1QyzmwqtkZVmJMj1hsYcbxvd8j5b5Gj+Cgu5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.9 021/157] ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx
Date: Thu, 13 Jun 2024 13:32:26 +0200
Message-ID: <20240613113228.229779857@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit c81bf14f9db68311c2e75428eea070d97d603975 upstream.

Listed devices need the override for the keyboard to work.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -630,6 +630,18 @@ static const struct dmi_system_id irq1_e
 			DMI_MATCH(DMI_BOARD_NAME, "X565"),
 		},
 	},
+	{
+		/* TongFang GXxHRXx/TUXEDO InfinityBook Pro Gen9 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
+	{
+		/* TongFang GMxHGxx/TUXEDO Stellaris Slim Gen1 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		},
+	},
 	{ }
 };
 


