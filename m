Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD71E199FAB;
	Tue, 13 Oct 2026 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895644; cv=none; b=Tdih81q8CnKkYGir4McL4o4WDioGpPRBeRzsbi/0psMNnZuuE9J9v5AsGpfBQK79ihi6aLH+MuO9EqPFWDhxQDtTbnQUILdjRCAraoRDnOdUtR0tEAp5sVqQKyUn9D2SDgi2qNeIVb6JqLZz2ei49gjfdBDtLCkFr3J1kc1Zr2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895644; c=relaxed/simple;
	bh=UbUF/KY9iGqrTELC1h//RLselGgTVGc5DseDfIJ2NyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqyYhrihhD9axMt4IHfwgUpytmPmbAQLCgKyq36Eg2MvYj4knC3Vd48pE+ZBITtj7kYx9uVEcGbjTt4dfzvWlRnLIfiu6cECviui8TtqneoFxbY4kDcrj81UzWLOSy0jKmiMuBwQqrkuJaRd1/t/McwjJWYKeu0qyZbkK4sV6nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/lN1BYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/lN1BYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF7D1F000FF;
	Tue, 13 Oct 2026 12:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895643;
	bh=76M2TgJ4AD5l/IKF/SbmW4eV8UsM/qUtJoUJldLAf+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/lN1BYc4tf6TdTrqzi+pXnoLmiBzoJiACnmcKwXnGG2By7JSvgf9uJaO8olNJ/DZ
	 IrhsWH9ID92ZTxF6SXL4rdwaqn2BrAnp5i2XRrt5ZUWJp3nlIqnF/b+IUXI3/oV5NW
	 vXQShYH9gLqc+LH2BFeQAupu+i8++uvwte3X3cps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/497] doc/netlink: netlink-raw: Add max check
Date: Tue, 13 Oct 2026 13:38:31 +0200
Message-ID: <20261013112916.070054239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Remy D. Farley <one-d-wide@protonmail.com>

commit bf5a54bc0e3d8962474fcd611f1266eba036232f upstream.

Add definitions for max check and len-or-limit type, the same as in other
specifications.

Suggested-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
Link: https://patch.msgid.link/20260303195638.381642-2-one-d-wide@protonmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/netlink-raw.yaml | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/netlink-raw.yaml b/Documentation/netlink/netlink-raw.yaml
index d8ae7f7365b08..d6d58ac63b7c0 100644
--- a/Documentation/netlink/netlink-raw.yaml
+++ b/Documentation/netlink/netlink-raw.yaml
@@ -13,6 +13,12 @@ $defs:
     type: [ string, integer ]
     pattern: ^[0-9A-Za-z_-]+( - 1)?$
     minimum: 0
+  len-or-limit:
+    # literal int, const name, or limit based on fixed-width type
+    # e.g. u8-min, u16-max, etc.
+    type: [ string, integer ]
+    pattern: ^[0-9A-Za-z_-]+$
+    minimum: 0
 
 # Schema for specs
 title: Protocol
@@ -270,7 +276,10 @@ properties:
                     type: string
                   min:
                     description: Min value for an integer attribute.
-                    type: integer
+                    $ref: '#/$defs/len-or-limit'
+                  max:
+                    description: Max value for an integer attribute.
+                    $ref: '#/$defs/len-or-limit'
                   min-len:
                     description: Min length for a binary attribute.
                     $ref: '#/$defs/len-or-define'
-- 
2.53.0



