Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4A68F49
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29C6C433A0
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677778007;
	bh=WyxaQ/Ar5yI/+OLceoeoBs+C8Ou68ZWdHY54J5np8xQ=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=0X5XvEtx/YURETzy4YbxMahJlWmanyJ3zQzAJxRWwPNrKiLFaCj79f2/pUqbUh7xY
	 mC77ML4HTLmbYC5WFovMQZtyZgpHzVM6zTeVUIKB6dpOFINVMcYFSNIlTpbX7/qFzb
	 uR6eZW2+DRPiTmPBU8SrF1TxnVK1R5IU/Hq5vN5M=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 02 Mar 2023 12:26:34 -0500
Subject: [PATCH v12 3/3] Another commit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20220825-test-endpoint-send-2-v12-3-9eb08a678d67@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v12-0-9eb08a678d67@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v12-0-9eb08a678d67@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.13-dev-14a61
X-Developer-Signature: v=1; a=openpgp-sha256; l=617;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=WyxaQ/Ar5yI/+OLceoeoBs+C8Ou68ZWdHY54J5np8xQ=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFIY7oSdfXf2xIInJcJfDG8wBh+vfK9WKNnydRLrrZxEx
 vmR8gqxHaUsDGJcDLJiiixl+2I3BRU+9JBL7zGFmcPKBDKEgYtTACbyfDkjw2bdFJFnN47XHtuq
 F+ZyI95qh3/u6/WLoyN4kpcsXu21N4iR4XTK12mV1r8Cbx1c/8y3tEaU16uxbOaBA8lpVn+j45z
 kWAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is junkiest.

Cc: Bubba Babootich <devnull@kernel.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
 README | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/README b/README
index 669ac7c32292..3fc69669ecd3 100644
--- a/README
+++ b/README
@@ -16,3 +16,5 @@ several of them using the Restructured Text markup notation.
 Please read the Documentation/process/changes.rst file, as it contains the
 requirements for building and running the kernel, and information about
 the problems which may result by upgrading your kernel.
+
+I added this line.

-- 
2.39.2

