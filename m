Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F30145B27;
	Tue, 21 Jul 2026 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654645; cv=none; b=kbfTZtK5tcLko5BEnYWAuApedyS2UD5TB9v9buPmQ0sJsPlzfsOABIxX0kmJEfgloDmHMUjbaXXaEOFJvYAj3+Ga2bX3ocvXM+9ZeYqbZIvcQLqNfz1kjoT2WB70v+sqAZ5190QUQusXmbghNbOQzzkqhxHMpYXGNtRjQHoa5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654645; c=relaxed/simple;
	bh=joJDFQPD5gFcDPiK+z5GJzKfY47USzCo3WQvyWPVnFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MFLLtwYUptrjN1PR0guR1+arM8UHhN+U6dAMI28jEKtJInpWgip81+DbgUynC+RBvZXF7hh7LdTxSNsg4JMy6JKvCNw+vnXTXwg9VxEGq0nopW72QlpxAmQia0p7H9WIRYkqBFN6J2H+q1z6Zch0WW5wCmrMovWOXC96ShExuOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCrsmQGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCrsmQGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B131F000E9;
	Tue, 21 Jul 2026 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654643;
	bh=y377k/8gNgSekltRHpvb/9wKG0tSNVtCu+9/7Ll7CSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCrsmQGyl5qaZ+oTk0nddTeaF4+K/LmtmYaRZ7pZVG0bV+CX9b7GsjgG2g3MxxNG2
	 /VJO6oUQ9bbW+fFSFGI0nW+jmX2Frw52j+Fq8/SMpKCVwCsX+lUJocGOzHzzaojnHS
	 JIO8bDEtr/K+/z2H4mxyKNnn+6to/helU9sUpyeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ahmet=20=C3=96zt=C3=BCrk?= <sivasli-ahmet@gmx.de>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.1 1782/2077] platform/x86: hp-wmi: Add support for Omen 16-ap0xxx (8E35)
Date: Tue, 21 Jul 2026 17:24:15 +0200
Message-ID: <20260721152634.778514412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chomal <krishna.chomal108@gmail.com>

commit 56b7981c6f21670c0a1a62e6d2f9afb380e2596d upstream.

The HP Omen 16-ap0xxx (board ID: 8E35) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile.

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_legacy_thermal_params.

Testing on board 8E35 confirmed that platform profile is registered
successfully and fan RPMs are readable and controllable.

Tested-by: Ahmet Öztürk <sivasli-ahmet@gmx.de>
Reported-by: Ahmet Öztürk <sivasli-ahmet@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221523
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260608134255.36280-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -261,6 +261,10 @@ static const struct dmi_system_id victus
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8D87") },
 		.driver_data = (void *)&omen_v1_no_ec_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8E35") },
+		.driver_data = (void *)&omen_v1_legacy_thermal_params,
+	},
 	{},
 };
 


