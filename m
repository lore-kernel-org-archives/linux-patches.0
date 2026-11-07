Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062360;
	b=SzLRoDVIxe+h/9Wi4FLjMab4K9EWWnaJoJdG6+yu60+x0P0dcClqhuCwt3TOMio3OI57
	 EnKgy7cvKo4lHqIgNbzZzj1lOhcRGGX6tEu78KEM+bLgRaZR0ONBJJgkqUBL/4mWpLZpS
	 pai8Yz0giXLc/v4eXqFYi96n+S+BEFE+5OqsNNfvs1XuomtxlAy8gB3dPp4j4W6vnYdPy
	 qhBCCSQI2TMuSgyIi7xXb7nQEcJXcP5lcJuYd8CX5/uI8YutL8QTqf+TGz3EpDlSx5kHv
	 2XlgNNGXlmnCvMIdp4f/yw1HvtQDU0dyDmcD4A7O8ZSqJymJT85wdLgJVci3mLUHoAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VDITY/3aqTiyw10Zap7kTA/nnSRpoe/FjdzhKD0EXHg=;
	b=M2SwAigo0L0SdKIiqaaN3wHx5Lpgni0iStO6S5gEMIALetToHqRRjz5ZZGwzfq4XuSM2
	 qWfgyjc60CMmO8tQ9Uewq+0WOOqNNW9Jomqu0yGmVL9zxBPxaHfIo57wo3ne3Hw0n89i9
	 OkLHP4Is0/Udl/eGdkaNJ149pl74DqzgQg1/uOuS1QnLxhs5SDHxFO+/c8A2JRapKad5B
	 VVg+a1AwVC+PYCoO+nCM3w/FHPYsSijG9esaGbRLhk3e2Rb0dYEnBoxsHpYNF1S9keaZc
	 dCOnASr0vCOuDOs+gn3BndZ7IGdCPGJKbxQQiwucNjaieZnoR/M5RS3sR9srzGvL74w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nX/WD3B3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93B9606A32C;
	Sat,  7 Nov 2026 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nX/WD3B3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D4E1F0089F;
	Sat,  7 Nov 2026 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062359;
	bh=VDITY/3aqTiyw10Zap7kTA/nnSRpoe/FjdzhKD0EXHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nX/WD3B3THDhmwq3owv3Z2XA+WK3WzSJs5n3opSkz/V0Mb7IHNSPo6E6rfCl9BlS3
	 k/SoUaCSc3DI9PF8oT9yybVh8/Lz414h/DvGIq+5Mfk2EvnpYfE5/Gk0yFzRjoAqic
	 4gRb7/1Yhsug1AR7i+7+Qolt9FDA4EfqdTLIjo/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1286/1536] platform/x86: hp-bioscfg: return -E2BIG from validate_password_input()
Date: Sat,  7 Nov 2026 08:55:02 -0500
Message-ID: <20261107135033.903304854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 34740f29f41a5..00e91ade56293 100644
--- a/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/passwdobj-attributes.c
@@ -70,12 +70,13 @@ static int validate_password_input(int instance_id, const char *buf)
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



