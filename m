Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F9E1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277D2C433C1;
	Wed, 23 Nov 2022 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197246;
	bh=HcPyuCp0n5QyO39P5sBaG+3b0bMiT9tVBLZuD1KrLw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=000GfdSMgXNxU7i6trtLpiX2X1tEw6MFkzSTBlYLsnG9F9DpqXoDo1SXY8DpXV0ZS
	 GS+p40lGXW1xI8WclUMIkYzqrP3Sz4JuwUVTgggTc/pe8UjDZKcCitN4zMZdcIcNHi
	 kzw+0hrnOpXdqZ05DMzAq5l9hH5dbwO3Qx6dGdAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.0 209/314] platform/x86/amd: pmc: Add new ACPI ID AMDI0009
Date: Wed, 23 Nov 2022 09:50:54 +0100
Message-Id: <20221123084635.003119513@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 6412518f5cb953cbd84b6746db9741bfc92be40a upstream.

Add new a new ACPI ID AMDI0009 used by upcoming AMD platform to the pmc
supported list of devices.

Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221109083346.361603-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -918,6 +918,7 @@ static const struct acpi_device_id amd_p
 	{"AMDI0006", 0},
 	{"AMDI0007", 0},
 	{"AMDI0008", 0},
+	{"AMDI0009", 0},
 	{"AMD0004", 0},
 	{"AMD0005", 0},
 	{ }


