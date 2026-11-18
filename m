Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028496;
	b=5EGUW6dsYPMAZ5q3+Eox2XvGabTzHn8jDNqMdnlWkb5BFhevRap6X8iqE8prd6EFbzCy
	 saTnZqW4l1BWS21EoSIs3DzVd6FUy06iLK0+V+yflKtQtg3vGzF1cKQr70WtcKzmIcStf
	 LK3CsEBzu0+bRnYxuGqaBXr7kW1rAbr8vXe7r4o7L2UpWLD9TK0PnO6WbmFPPSMGrjkI4
	 szBK5VHRfBZLy9pZgu8gBavS/3YZsDgbg0aMMBdXUYmFzb5fJKBJ3I/p8aYYg4lxxHKuX
	 X2xwgC9JnM2bDrZiAQxBCY2hbVPNs4W23BnIaLwyQZOqi90PkXW9NGrRODnCv4SQrnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NqeX/DF72hFe1OQViLnGc66WkfqlHnuKg6YJcIWBFME=;
	b=jR06HlpdWASOfOmJfeb9XCqT0pQV8P/rNyDoxFT7lnM7nm10xNcZ8KxoOcN3c4XjtByx
	 0h4tU4yBfmm2K1f/pBmd9aW/I8GyN3WhkSwYtBeSAFgbf8KsMncvZuoV2iMCyZOlA7BPe
	 g/aManM7GJ+LAoL0HHGFbrF7zuuKmh7OO/6oUsJlz3FH//kIQQdaRrEFMtfMlXIE7Tx5h
	 08eVczYkk5AWHN6dZH5MTzZ/A0CYdDUbqyOCqcCsNSdJ7qigEoxTh82ZuCzMURFX9Odju
	 kQFkVdTQOJ1Ep4F56GELcnbPhElyALl63S1+Ct0NVjZe8zvw3aq6bcIOQfzzz0uTKCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVVNWG3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAE8606A31C;
	Wed, 18 Nov 2026 19:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVVNWG3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D76B1F000C4;
	Wed, 18 Nov 2026 19:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028496;
	bh=NqeX/DF72hFe1OQViLnGc66WkfqlHnuKg6YJcIWBFME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVVNWG3Q+ltZ7FoGEaCj+yUoNMkvqWY+vXIynYV21C1XbxlvSwUvhVdKQB36h6UQy
	 8TyHeux1oxQCszLPRUtpUXgsUAO4h6CmveF/yh7dEIZfC1I2Ea5NRu24DfKlWUJqLj
	 oTW5QqpH/JT4dmWZQBP8v53pTiynqjEJVLT73qkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Rong Zhang <i@rong.moe>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0017/1756] platform/x86: ideapad-laptop: Evaluate ACPI methods exclusively
Date: Wed, 18 Nov 2026 15:35:44 +0100
Message-ID: <20261118150008.622923189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

[ Upstream commit f91c2cd6dbcedf52e227b2eea8d7b99ecbac7552 ]

On some Lenovo IdeaPad and Yoga models, the battery _BIX takes the EC
AML mutex and then calls the serialized RDER through RDIF, while GBMD
calls RDER first and then takes the EC mutex. When the two run
interleaved they deadlock until the mutex acquisition in RDER times
out, and GBMD returns garbage that is reported as both charge types
being enabled.

Evaluate all methods with the exclusive helpers, so that GBMD never runs
interleaved with the battery methods.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221065
Link: https://lore.kernel.org/all/58586fa666f09c209f9d7fe8c692a8bdda6d4410.camel@rong.moe/
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Reviewed-by: Rong Zhang <i@rong.moe>
Cc: All applicable <stable@vger.kernel.org> # 80892972ff23 ACPI: utils: Add exclusive AML evaluation helpers
Link: https://patch.msgid.link/20261018122348.679126-1-aliamemis@disroot.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index c7e8bcf3d6239..6349defc17385 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -282,12 +282,16 @@ static void ideapad_shared_exit(struct ideapad_private *priv)
 #define IDEAPAD_EC_POLL_MIN_US 150
 #define IDEAPAD_EC_POLL_MAX_US 300
 
+/*
+ * On some models GBMD and the battery _BIX take the EC mutex and a
+ * serialized method in opposite order, so evaluate all methods exclusively.
+ */
 static int eval_int(acpi_handle handle, const char *name, unsigned long *res)
 {
 	unsigned long long result;
 	acpi_status status;
 
-	status = acpi_evaluate_integer(handle, (char *)name, NULL, &result);
+	status = acpi_evaluate_integer_exclusive(handle, (char *)name, NULL, &result);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
@@ -309,7 +313,7 @@ static int eval_int_with_arg(acpi_handle handle, const char *name, unsigned long
 	in_obj.type = ACPI_TYPE_INTEGER;
 	in_obj.integer.value = arg;
 
-	status = acpi_evaluate_integer(handle, (char *)name, &params, &result);
+	status = acpi_evaluate_integer_exclusive(handle, (char *)name, &params, &result);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
@@ -321,7 +325,7 @@ static int eval_int_with_arg(acpi_handle handle, const char *name, unsigned long
 
 static int exec_simple_method(acpi_handle handle, const char *name, unsigned long arg)
 {
-	acpi_status status = acpi_execute_simple_method(handle, (char *)name, arg);
+	acpi_status status = acpi_execute_simple_method_exclusive(handle, (char *)name, arg);
 
 	return ACPI_FAILURE(status) ? -EIO : 0;
 }
@@ -379,7 +383,7 @@ static int eval_vpcw(acpi_handle handle, unsigned long cmd, unsigned long data)
 	in_obj[1].type = ACPI_TYPE_INTEGER;
 	in_obj[1].integer.value = data;
 
-	status = acpi_evaluate_object(handle, "VPCW", &params, NULL);
+	status = acpi_evaluate_object_exclusive(handle, "VPCW", &params, NULL);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
-- 
2.53.0



