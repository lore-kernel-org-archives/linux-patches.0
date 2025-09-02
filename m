Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D665324B3A;
	Tue,  2 Sep 2025 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819855; cv=none; b=jqexK7IzTDt8xIulSgzbCdAQ8XAt8I9xnuspZAhy45pd6EzugXwjPQpNnRGcYRW/QnPo+1rgcOCVdstPr9naPd606gZzNima+SgGBoyMjP9dg33ire5L+D51roeqBLuvdrBEi+o0+pJs2Z51udZKzXsUG9e+8C3Csnd/qy60Z8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819855; c=relaxed/simple;
	bh=qRcrj+cpq2fs8I2BAWKyPO82WK4laO67SP/DSgB+Z0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp36WsejDGe4e8Db66eRyLOMrfKTN4TYoDoWRUUoTOeLUpXB83H0R8EYTzo2lFAq+x0HeIlEmqAryYcgeqqzpo1G6O69fy6X+1259v+XZMbnyO9PBoZR51jlnO7YqtbG3+gElUD119m+c95dDZFO3enCfehjDjawb56OFylvJyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRexgJvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRexgJvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6BFC4CEED;
	Tue,  2 Sep 2025 13:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819855;
	bh=qRcrj+cpq2fs8I2BAWKyPO82WK4laO67SP/DSgB+Z0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRexgJvijzMpHSKi9lRR9M7uohJlAIqpx8rUfpkxTPHwNLeJxnSaVyGf7dj4dehTO
	 MdeARcSq2NgRdoQjaB08v6Z622X1w3s6tX8+9R2bmFQXEB5DId/HCqNO6mU5bEmkBs
	 vnlCwwuRt+qozmaC6NWZNX6SZRQq8MWOBELbxsdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 17/95] ACPI: EC: Add device to acpi_ec_no_wakeup[] qurik list
Date: Tue,  2 Sep 2025 15:19:53 +0200
Message-ID: <20250902131940.276267564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 9cd51eefae3c871440b93c03716c5398f41bdf78 upstream.

Add the TUXEDO InfinityBook Pro AMD Gen9 to the acpi_ec_no_wakeup[]
quirk list to prevent spurious wakeups.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20250508111625.12149-1-wse@tuxedocomputers.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2329,6 +2329,12 @@ static const struct dmi_system_id acpi_e
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		// TUXEDO InfinityBook Pro AMD Gen9
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
 	{ },
 };
 


