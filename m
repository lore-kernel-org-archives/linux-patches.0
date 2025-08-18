Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA878BEC;
	Mon, 18 Aug 2025 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522687; cv=none; b=dsEfhUxb4Kw++moSGQGCyoCAR+nB/ChqSL73wAXsl2EfsDvg6ZfSrXF5/64L7jEeU1ih9L6WKD3pZz34TrnEBkDd6V4kxMygat7EI+z3BLiKOxLMHPtzFkv8rHmk8ocdTYXYsT0BE2SXPP/zNO0SZCU0ztb1PHI9BmlqvuV35KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522687; c=relaxed/simple;
	bh=TXwvzAv8Hwi3ybp6dP9DUfbw0AF0X5wtMAFKGdpCjaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMC8WO6GIqiT236hwszSIsagO3MArg7u1R9zn5I2VkdL3bgYPm+FjAgLAko/SqflSfVXTbPmJvUD1YHEDFF+DE38NSUCtpmDFSfQzyHLkVzQsI5xaPXDoNmWBgG8vyGagGmzulHUN7KGg1yWZtJu7iJkUWPVm8f+8f4CzmUhm/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mq/5aQ3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mq/5aQ3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1023C4CEEB;
	Mon, 18 Aug 2025 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522687;
	bh=TXwvzAv8Hwi3ybp6dP9DUfbw0AF0X5wtMAFKGdpCjaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mq/5aQ3J4V9E/pcTjmg/gxgjcfiQYBqgYa1ZSZgDwS6o/V1+M6KX1+FFr5tkzfTCi
	 LYmD0BnAdR1mUoazaAhw9EKKWzDqSYqP1L2zGXBwXE2vAfK1S6bBuSDn/00g+GJ5b+
	 E/KEGNXyC1OinlFhRoiLhU53RHBwszk+U4R52ZoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 389/444] thunderbolt: Fix copy+paste error in match_service_id()
Date: Mon, 18 Aug 2025 14:46:55 +0200
Message-ID: <20250818124503.484951701@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Biggers <ebiggers@kernel.org>

commit 5cc1f66cb23cccc704e3def27ad31ed479e934a5 upstream.

The second instance of TBSVC_MATCH_PROTOCOL_VERSION seems to have been
intended to be TBSVC_MATCH_PROTOCOL_REVISION.

Fixes: d1ff70241a27 ("thunderbolt: Add support for XDomain discovery protocol")
Cc: stable <stable@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20250721050136.30004-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/domain.c
+++ b/drivers/thunderbolt/domain.c
@@ -36,7 +36,7 @@ static bool match_service_id(const struc
 			return false;
 	}
 
-	if (id->match_flags & TBSVC_MATCH_PROTOCOL_VERSION) {
+	if (id->match_flags & TBSVC_MATCH_PROTOCOL_REVISION) {
 		if (id->protocol_revision != svc->prtcrevs)
 			return false;
 	}


