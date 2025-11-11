Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DB324113D;
	Tue, 11 Nov 2025 00:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822797; cv=none; b=Ns2wSO+v/6rVpaxsYkkuBwqhIKd/tO0IfFw6edzZJ3o2dSUupTVdxl7jQ/kH0aTIXwYHYxtLEz0OskWQIaSHKk+cMGjqWVqylS1HjLfa83+oFYGBeugQyX4d2yECuE3LpZSifVooukg2r9ZEFJfHRzLYqLkvMWcmRjXIG6RdCHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822797; c=relaxed/simple;
	bh=XqmY4NC5c2UI1ZVVMEbeWzWl4BZNoA1XVEJF9PwFdHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbQVss1l7HkZHxYho/H2+N297e3qInH/hl8fNMXieGkGfwZSLXY8vzvER9uLZzH/cGW9jfp/mCzU0YLcXKbsoGNUKBvlkq/xnw9F/0g8jYCvUMYEdKxVt/BZRJ3WAkPZEcSbAuAMLtKDqL9Mb9Szcq2nYzmpPkDD250z/Wk0X+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgId473N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgId473N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A4DC19425;
	Tue, 11 Nov 2025 00:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822797;
	bh=XqmY4NC5c2UI1ZVVMEbeWzWl4BZNoA1XVEJF9PwFdHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgId473NcOtbkobSagft3NtAxvzeQmbeT7XGqemeXxJ61gQuh3mH1FDtcKn/ZTIVp
	 CfTpT/Rf4pIk/Jx30RqCMhYKU7jVT21NQIdWejAPqYCzxX0qWpu6jZBMW2gE0aMg63
	 2kCTiAFE4WenbqD5Ldj5Kta3cpnpXHUirF5Mpfkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/565] ACPI: sysfs: Use ACPI_FREE() for freeing an ACPI object
Date: Tue, 11 Nov 2025 09:39:18 +0900
Message-ID: <20251111004529.250337205@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 149139ddcb99583fdec8d1eaf7dada41e5896101 ]

Since str_obj is allocated by ACPICA in acpi_evaluate_object_typed(),
it should be free with ACPI_FREE() rather than with kfree(), so use
the former instead of the latter for freeing it.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Link: https://patch.msgid.link/20250822061946.472594-1-kaushlendra.kumar@intel.com
[ rjw: Subject and changelog rewrite ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/device_sysfs.c b/drivers/acpi/device_sysfs.c
index 3961fc47152c0..cd199fbe4dc90 100644
--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -464,7 +464,7 @@ static ssize_t description_show(struct device *dev,
 
 	buf[result++] = '\n';
 
-	kfree(str_obj);
+	ACPI_FREE(str_obj);
 
 	return result;
 }
-- 
2.51.0



