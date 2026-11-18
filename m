Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036571;
	b=AmXD9AKevIUNe9VbOFxSLOIo0YwvcmofGwTt06erRKcEwdldq227VVd3K3SAcC3Nkxwx
	 ds9BvPlSLQZeXHVjdgMmGkHGUcOGjCqLp7JKg4MZTQb46dm4SVwKwu0HphG3cTl27uDmS
	 IUOiGlpyvJbCcsMuid1YXThsJ+pJlgSDX+F+UiZWn8zyI1biVYt+yAplwVJq658A6QvSi
	 Bec5GrtZRCeyIt4VC5kMz9sb3ERS/yg2tJQXjMdr41gVoqMaPCoKDOThwEuuowoIaMdna
	 9Xnrurq+YSlfoI8BH9sBBznjKrixsS/hRAFv8aIwlwBkeEbuQQD6gKkB1vKvpPdugrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036571;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9dFDcB09xvc4Pw5fWVdnslXqOHKxrEjeoNXZMStYQYs=;
	b=LTJD8tTOK927dJ0Oxl5b/jR1ZQQiywhvoribOQdkXtCuCYIwmK8HKNzVJrZC0cc3fnOr
	 xvY0f0KJwIgjA4GaNsKklzevGz9eTshvdEmDnfqSQlYA3ljHR71MNo2TmP1lpMOHFTEN1
	 IKIg/wyS9J93P8LNuD5GGsN0UlO52agDPzOpVKaIQacRNlCw4Cdln34c/2qNV/+y2KU/U
	 4wZdlVlwpx7SGmhVv09uYJWYjqTLYyTgiRrDbAnmZ9DFdRpEEMnE/ikk52SH4jrHg+TSu
	 i4MA+wPE3CX4BKX5k6BwM7nXGLM7MtFCQCjlCNdhYKdVGjE7603f5/d2S1fNSd7dvFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QafMxDYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F690606A325;
	Wed, 18 Nov 2026 21:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QafMxDYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694D41F000C4;
	Wed, 18 Nov 2026 21:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036571;
	bh=9dFDcB09xvc4Pw5fWVdnslXqOHKxrEjeoNXZMStYQYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QafMxDYpH3VCpRQvjjuMGjT8ypkC5DgS+o0xN7BmxKTqfW7VR+jKlw//1xKHSkxB9
	 vZQzlavMTvz8cyLFsJr3oMYpIkbRqpTt+HQFMyb/rmBg6qlqorrlyK5g9Cs1qFD5cs
	 /mooAh8Vzk2J7TYL9HhKFx7OMnR+bVIptbAb8Ijc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1105/3318] platform/x86: hp-bioscfg: return -E2BIG from validate_password_input()
Date: Wed, 18 Nov 2026 15:28:47 +0100
Message-ID: <20261118150353.143113999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit a4f19c589b21e18567d3c0ac7b9294f81e29b1de ]

validate_password_input() returns the positive INVALID_BIOS_AUTH on
rejection. store_password_instance() skips the store on nonzero ret,
but its final "return ret < 0 ? ret : count" treats the positive value
as success, so userspace sees count instead of an error.

Return -E2BIG for an invalid password length.

Tested on HP EliteBook 840 G2 (Fedora 44, Linux 7.2.7): writing 999
bytes to current_password returned 999 before this change.

Fixes: 8646a3b5ee3a ("platform/x86: hp-bioscfg: passwdobj-attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://lore.kernel.org/all/20261007134711.473857-1-meatuni001@gmail.com/
Link: https://patch.msgid.link/20261007134711.473857-4-meatuni001@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
index b165f9b056e6a..d36f75ed1d773 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -71,12 +71,13 @@ static int validate_password_input(int instance_id, const char *buf)
 		length--;
 
 	if (length > MAX_PASSWD_SIZE)
-		return INVALID_BIOS_AUTH;
+		return -E2BIG;
 
 	if (password_data->min_password_length > length ||
 	    password_data->max_password_length < length)
-		return INVALID_BIOS_AUTH;
-	return SUCCESS;
+		return -E2BIG;
+
+	return 0;
 }
 
 ATTRIBUTE_N_PROPERTY_SHOW(is_enabled, password);
-- 
2.53.0



