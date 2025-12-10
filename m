Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4829779DA;
	Wed, 10 Dec 2025 07:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351886; cv=none; b=tXAlDnureK0i+tLVw4yDMdWsyNrUHEQ9yULXWzaVzh3F5/wq0iVk4C2boDafICmV0UUjnT2D/G41BxMUihq41nsPtVCJTUbjIe7nzmPJjb45yTs8pqrgw8uqR257Jc4KU7CiQ0Z10IJNmLrOpfxse3ErHogxndwYgMnH02htEY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351886; c=relaxed/simple;
	bh=DzCIN0HQ4ltEyRk+hgDFuD1VT2ttjLYj3sEev2MbFEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1GLbJq5TuffL0JPUxA3/LSr7l4o/XPDYtkSg8t5kN/R7OOTirPDJcJwyIsmSyaqB3e/PCx7CSwOIlenBcaXqQhV5w/aPQB7BhJvGcFhDE8JudzSUwmmMtF6A0ZAQR0RCJMPDQRQTQpTCUthAPjSoDWCmXidx18sKAaPT25awFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sE3YNwfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sE3YNwfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCB4C4CEF1;
	Wed, 10 Dec 2025 07:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351885;
	bh=DzCIN0HQ4ltEyRk+hgDFuD1VT2ttjLYj3sEev2MbFEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE3YNwfYZRlEHZlG5MlYxgilSqSEPmf2jd9yKNr/ZOqPmmL3Vuf61b4BDRsJWZViW
	 yOhe5ljpRAMt/5eDbLi9bTIDWnj74ozLXjpsENvctyLMZ/s1j9663rliQwGGm3Ugl4
	 V5/bxcJqIz2+4nk1e7qhOorARxK72WKXv51kkVOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.12 05/49] Documentation: process: Also mention Sasha Levin as stable tree maintainer
Date: Wed, 10 Dec 2025 16:29:35 +0900
Message-ID: <20251210072948.259816764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

commit ba2457109d5b47a90fe565b39524f7225fc23e60 upstream.

Sasha has also maintaining stable branch in conjunction with Greg
since cb5d21946d2a2f ("MAINTAINERS: Add Sasha as a stable branch
maintainer"). Mention him in 2.Process.rst.

Cc: stable@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20251022034336.22839-1-bagasdotme@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/2.Process.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/process/2.Process.rst
+++ b/Documentation/process/2.Process.rst
@@ -104,8 +104,10 @@ kernels go out with a handful of known r
 of them are serious.
 
 Once a stable release is made, its ongoing maintenance is passed off to the
-"stable team," currently Greg Kroah-Hartman. The stable team will release
-occasional updates to the stable release using the 5.x.y numbering scheme.
+"stable team," currently consists of Greg Kroah-Hartman and Sasha Levin. The
+stable team will release occasional updates to the stable release using the
+5.x.y numbering scheme.
+
 To be considered for an update release, a patch must (1) fix a significant
 bug, and (2) already be merged into the mainline for the next development
 kernel. Kernels will typically receive stable updates for a little more


