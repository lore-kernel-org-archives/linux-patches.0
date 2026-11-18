Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022469;
	b=fy4KX1kG0NNIc3zvcoN+HmA6G9uNKdELF5+6XkIgEfZur4qpbS2glYguv+kFwsFOPnF2
	 lq5vK8+D9MWD3aezKctF1JVktg+R3xGn+jJcvr9D38Ebf/zaLIzwsQJbKGgV/ZidIKWFp
	 pZ5rNt4WYs0HWpMakyhVHHD6fYOHmH/0EMlW/SslCoLFm/dKnvCNrA6fOBJIs4rxPERlw
	 yqL8m97IZ3ZQVz0mQ+/bkBb609H7qfDCaA/zoHE6W299QDqthTLf1bCCKwkblh+XXi1W2
	 hoQQiV/fWqwf5dsRZS+cvGy98dSF3bynGhuoIQU4NxLVy7JLN+2ZGBJy7pU0YksCP9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HULEC8RByCMuHtwbtJuGiOyLLV4Q3vzG8mhBRVQEFgc=;
	b=l2Jsu9u0lfnlPMhefhnHjeQAvVGh9rGF1caaO3tfyTcHMxfZNqnKfOlV9htguFsiqZG4
	 vl1tWRkWl3WGY/yxjRQ8UkvDQTS2TSFxgQuP56c2dIU2FTla6ziax1vrux65H5hOPJHrt
	 uh/0CAJvXuzbHZAx3rKd9umO0UBcKKcI7+rboBWpLDZzhszNbCv70xJlZg+oW14NIA7UD
	 Mz8LVcdaP11ww1DcqtjI7zkddXbxVn/UjLcCVus0z4XcxOJ9CjvXUr6WlAjdhWqiuJSx/
	 g91YArwa2FnPNyfPFcUoC4BLssr9/2YgT80uDytYGMICZ4oAkiyNVnltw5Ule9AFGsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzYQ3jew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F35606A320;
	Wed, 18 Nov 2026 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EzYQ3jew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2658C1F000CA;
	Wed, 18 Nov 2026 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022469;
	bh=HULEC8RByCMuHtwbtJuGiOyLLV4Q3vzG8mhBRVQEFgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzYQ3jewfgK10XFD6TQcg5KUkVBUWkPWzJPJqg/SR6ni7VEZMk0R/05USX0moZPmS
	 ZCRD47GI4O6uzEllJ8KVZJBrHXZVEJp/gI/rF591zfPLSNPH6z1p+EYxAmyCQ4DhkA
	 gdTCZZ5WMQ2t9I+H/kExDJKsh7RxgCU6KRV7nrmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Rong Zhang <i@rong.moe>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0024/2151] platform/x86: ideapad-laptop: Evaluate ACPI methods exclusively
Date: Wed, 18 Nov 2026 15:29:19 +0100
Message-ID: <20261118150122.533388443@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/lenovo/ideapad-laptop.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/lenovo/ideapad-laptop.c b/drivers/platform/x86/lenovo/ideapad-laptop.c
index fcebfbaf04605..690311eb930d1 100644
--- a/drivers/platform/x86/lenovo/ideapad-laptop.c
+++ b/drivers/platform/x86/lenovo/ideapad-laptop.c
@@ -285,12 +285,16 @@ static void ideapad_shared_exit(struct ideapad_private *priv)
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
 
@@ -312,7 +316,7 @@ static int eval_int_with_arg(acpi_handle handle, const char *name, unsigned long
 	in_obj.type = ACPI_TYPE_INTEGER;
 	in_obj.integer.value = arg;
 
-	status = acpi_evaluate_integer(handle, (char *)name, &params, &result);
+	status = acpi_evaluate_integer_exclusive(handle, (char *)name, &params, &result);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
@@ -324,7 +328,7 @@ static int eval_int_with_arg(acpi_handle handle, const char *name, unsigned long
 
 static int exec_simple_method(acpi_handle handle, const char *name, unsigned long arg)
 {
-	acpi_status status = acpi_execute_simple_method(handle, (char *)name, arg);
+	acpi_status status = acpi_execute_simple_method_exclusive(handle, (char *)name, arg);
 
 	return ACPI_FAILURE(status) ? -EIO : 0;
 }
@@ -382,7 +386,7 @@ static int eval_vpcw(acpi_handle handle, unsigned long cmd, unsigned long data)
 	in_obj[1].type = ACPI_TYPE_INTEGER;
 	in_obj[1].integer.value = data;
 
-	status = acpi_evaluate_object(handle, "VPCW", &params, NULL);
+	status = acpi_evaluate_object_exclusive(handle, "VPCW", &params, NULL);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
-- 
2.53.0



