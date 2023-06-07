Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34DD39231
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78647C433EF;
	Wed,  7 Jun 2023 20:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171371;
	bh=XoNTfPVcj/zDFprYglcjvKbAP5hhuU89V9zc+Z8J8pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=InRup/h89d5v71lQq46928QFujmGxuLnZGLxUUllvs+KV3e9SexwIQ3hTYmHmtBxc
	 JKa6JaoPBMOnENil2ENVTuQNCZg/dMuYMKEssKpxiooPGN/2SyC/EmFb3WMzX/O1mT
	 U9/le3Z6YyYfcpFnkGVFUXRr4EyudARQ45qnvez0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Borowski <kilobyte@angband.pl>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 75/99] ACPI: thermal: drop an always true check
Date: Wed,  7 Jun 2023 22:17:07 +0200
Message-ID: <20230607200902.577884111@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Borowski <kilobyte@angband.pl>

commit e5b5d25444e9ee3ae439720e62769517d331fa39 upstream.

Address of a field inside a struct can't possibly be null; gcc-12 warns
about this.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/thermal.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1153,8 +1153,6 @@ static int acpi_thermal_resume(struct de
 		return -EINVAL;
 
 	for (i = 0; i < ACPI_THERMAL_MAX_ACTIVE; i++) {
-		if (!(&tz->trips.active[i]))
-			break;
 		if (!tz->trips.active[i].flags.valid)
 			break;
 		tz->trips.active[i].flags.enabled = 1;


