Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CC63E5EF8;
	Tue, 13 Oct 2026 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892818; cv=none; b=phP3+WuannFoQJTRr3COeUj8LCSWlIUw5y6ZXgHHMNksKAmOmFY5ehjF+qTNSSK7qJv4MHYyfk0jFA5LpKrQgZSlbaosnC5aQ+XJARynBHM236es3WxEGbzOl+QbvP1qqyL7caOFZV60iJbbQ+VneTboPOWAJcSS51+CeqLJWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892818; c=relaxed/simple;
	bh=W8JBlmRcNS8SZ+WrUkbzxk7nZkpkqGOqpiyH8Q83ZNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFgaS7cHs9DPZy3yBt/T1kG1ZUyvxwJUyUKuvXapjddwmMUbP6y6Aqjv7i0J28MCUuVCdNLONTYcU4JN3vWh2/mpjSGOHC33L2+MJ+DUSY1I/N0EHZlUwyNH+D4a6MWTNU6vWMAo6kzIfcfv7yfIgdlhPP9B/nZgdMOc0rCp954=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrX/9Ljz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrX/9Ljz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21481F000FF;
	Tue, 13 Oct 2026 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892817;
	bh=EKj+fMJ0iEHI0Bm5OmKgpp2aI/FzYk9dllDCnJz+vqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrX/9LjzCsFBUI7jSISrHA9R/k4zJ6NCINH8aRpvOVVhA9hqdkfQl+uRprwZOmeGP
	 rgUJZxHTPspkdDr3zLV8nmTOIW8Bc+xV1Rrvlb3Q6lRtG7sJ9P86JJ/A2AlVJWCcAi
	 N/bAIMaDJ7f0RQERRKp3MCaP4zxTj+aLD1ubskBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	"Remy D. Farley" <one-d-wide@protonmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/621] doc/netlink: netlink-raw: Add max check
Date: Tue, 13 Oct 2026 13:30:03 +0200
Message-ID: <20261013112921.061542505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Remy D. Farley <one-d-wide@protonmail.com>

[ Upstream commit bf5a54bc0e3d8962474fcd611f1266eba036232f ]

Add definitions for max check and len-or-limit type, the same as in other
specifications.

Suggested-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>
Link: https://patch.msgid.link/20260303195638.381642-2-one-d-wide@protonmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/netlink-raw.yaml | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/netlink-raw.yaml b/Documentation/netlink/netlink-raw.yaml
index f7c905c999365..be8b3717a6400 100644
--- a/Documentation/netlink/netlink-raw.yaml
+++ b/Documentation/netlink/netlink-raw.yaml
@@ -19,6 +19,12 @@ $defs:
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
@@ -279,7 +285,10 @@ properties:
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



