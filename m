Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1392571CE;
	Thu, 17 Apr 2025 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913240; cv=none; b=AA5oSB/Ybqi4GURpAm//6ksXBDOX5FZTDrvZIuLASQOhAplid+VsCm4G6C1ERGGai7u0acz6VCV9c0Hw9DUTFkptvZGkdFwrL7gE5w+9k/EPtB9RKFq6thP/d5dmjOQmTk7WLQUyggiNpKpI//mF2gIAIhUEpHUaK1NImK9z1jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913240; c=relaxed/simple;
	bh=p/4XBzDTM33a/Ve3Y1w4yGLOomzNNAPlma9QXIxywvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1dSaHIKlgVQMh3Q5OmSrEp/JOD8h4VSzHLg1QzgP6pQeGFWPbSLn6o7//XNzxMV0Z3rhmFdp5oV7p2NKEpJBNU2S9Q1c7h0ehuK1Wu+35fPVazJADfdA465U6QIQwgI2eopBKwUGZjHa+dxmGyXBG6q2wFsbAZgrXqwCY7VPis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZtATAsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZtATAsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EE7C4CEE4;
	Thu, 17 Apr 2025 18:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913240;
	bh=p/4XBzDTM33a/Ve3Y1w4yGLOomzNNAPlma9QXIxywvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZtATAskp/rrF/aV0sn30et1hgfH3r92qJ5OBQFqv8N296I6CUYEUf7dy2sKYWyGj
	 gcmPGu0iKENFHQ+1tGthuHnFrXKJxWGyZtnlny7yp6A+sagNIraMDX/LD3rwjMjmT/
	 3/x/5xkpjxAtBXVuKJ8TE0dZNhMirGtcLj7yCmaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 274/449] net: dsa: mv88e6xxx: fix internal PHYs for 6320 family
Date: Thu, 17 Apr 2025 19:49:22 +0200
Message-ID: <20250417175129.085786836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

commit 52fdc41c3278c981066a461d03d5477ebfcf270c upstream.

Fix internal PHYs definition for the 6320 family, which has only 2
internal PHYs (on ports 3 and 4).

Fixes: bc3931557d1d ("net: dsa: mv88e6xxx: Add number of internal PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: <stable@vger.kernel.org> # 6.6.x
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-7-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6259,7 +6259,8 @@ static const struct mv88e6xxx_info mv88e
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,
@@ -6286,7 +6287,8 @@ static const struct mv88e6xxx_info mv88e
 		.num_databases = 4096,
 		.num_macs = 8192,
 		.num_ports = 7,
-		.num_internal_phys = 5,
+		.num_internal_phys = 2,
+		.internal_phys_offset = 3,
 		.num_gpio = 15,
 		.max_vid = 4095,
 		.max_sid = 63,


