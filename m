Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8D3221F0C;
	Mon,  2 Jun 2025 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872182; cv=none; b=dEWIB7Zfdn5V8QW1T0Z1l33OLe6YTTsZKzNPhDEVzbGV0XCKV7vF6Oa90+oYbGavS1/JNrmTM6mvJop11RjeOFH7hZeLwCB/xOU0C2g6Lz18Y485IjWiTPDbOpUguJ3BjJHcFk+iM758Y2JsADUyVxVufDiV8spAQa8XA4FUr7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872182; c=relaxed/simple;
	bh=bscFpz+XabX3jpKovWD4/q7PWEokMLZeKGRnYz83hBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUtKGF4Zasa2GDfJSsHhdT8hgd81B+xgHZIc2uIAXunhbf/P46itnRVkFg4M4HiGQiNhv/lJ21b5aNWG2BBbGdM7Ddzs9ioKnRVSmeHH8n67qDt39gDtEyxCMaZoxWtmV6lg09uriEAAVHBR7Y7EB7ug/QTs+p+w9SIVYgufzko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjZcb1Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjZcb1Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935A7C4CEEB;
	Mon,  2 Jun 2025 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872181;
	bh=bscFpz+XabX3jpKovWD4/q7PWEokMLZeKGRnYz83hBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjZcb1YljAnioG+R3w9SXCXqPOlQVVwwTTc7iCPZxWDD5WCbnsqur4i12zSEFk1rH
	 qrxg0zGaCYJZSY6uXGm/b9ZLqafyXJPxwetO2+ja5hbXjkpD512bVpaiIAQz3993yX
	 3NEA9u1BNn4M5gXgEzDJqtnYYI0x/niO9VGMeJlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.15 44/49] perf/arm-cmn: Add CMN S3 ACPI binding
Date: Mon,  2 Jun 2025 15:47:36 +0200
Message-ID: <20250602134239.672339078@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 8c138a189f6db295ceb32258d46ac061df0823e5 upstream.

An ACPI binding for CMN S3 was not yet finalised when the driver support
was originally written, but v1.2 of DEN0093 "ACPI for Arm Components"
has at last been published; support ACPI systems using the proper HID.

Cc: stable@vger.kernel.org
Fixes: 0dc2f4963f7e ("perf/arm-cmn: Support CMN S3")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/7dafe147f186423020af49d7037552ee59c60e97.1747652164.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2651,6 +2651,7 @@ static const struct acpi_device_id arm_c
 	{ "ARMHC600", PART_CMN600 },
 	{ "ARMHC650" },
 	{ "ARMHC700" },
+	{ "ARMHC003" },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, arm_cmn_acpi_match);


