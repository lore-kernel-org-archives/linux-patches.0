Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A177219E8F;
	Sat,  7 Jun 2025 10:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291095; cv=none; b=mNWML6ovuB0XDCOIsjn8s/MzaWszgGWqLpS9TdWryWHjLjl/UBVFu0Ys0kNK4nr4zpLk5oTEmqYNP5GchYPJtFqXVIpkFS6RXriCpIwbMikrAaZIiBqIO6HZZQV4SyYtdkwL8+ObWS4vffnoAiZh2KfXAHceDQEp1P7PR1RSv6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291095; c=relaxed/simple;
	bh=Gaj/2sq2C2qyKTfYlQsuBVEZ59lQwE/cUdz3ULkPd/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5AZmuwBSXGVYzEp8JV3vldZmVpTcLTVauChu5JHTu2Sg48KqdymdxGuWQNzUWUG6au0YWBjqU95ahvhRe8VMWUXI+ItdTrWo7bFB/aGKKXE7qaSJnLoYRww1AHYwoUrV5GgbWSuDhHa3PdY4AxQWBt0BYgOm1VGi1suQsd4guo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/XUuxqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/XUuxqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24AAC4CEE4;
	Sat,  7 Jun 2025 10:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291095;
	bh=Gaj/2sq2C2qyKTfYlQsuBVEZ59lQwE/cUdz3ULkPd/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/XUuxqctxDdEcdqPYJOY4Hx7VxxLa8mEpG+Jtg3JF495Rh0Ob7sicMe4atoazfUZ
	 fFgf1Wsjr7+L23saEJezGy9UeZZLkCNUTUKetxmeOE3CO/7Q03ztYCTU2UWIfO15PN
	 1FuCQNwQUwr3nhpZmn5KqMSTKO62nZ6rVGo3Ce50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Yeh <charlesyeh522@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.15 21/34] USB: serial: pl2303: add new chip PL2303GC-Q20 and PL2303GT-2AB
Date: Sat,  7 Jun 2025 12:08:02 +0200
Message-ID: <20250607100720.545345670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Yeh <charlesyeh522@gmail.com>

commit d3a889482bd5abf2bbdc1ec3d2d49575aa160c9c upstream.

Add new bcd (0x905) to support PL2303GT-2AB (TYPE_HXN).
Add new bcd (0x1005) to support PL2303GC-Q20 (TYPE_HXN).

Signed-off-by: Charles Yeh <charlesyeh522@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -458,6 +458,8 @@ static int pl2303_detect_type(struct usb
 		case 0x605:
 		case 0x700:	/* GR */
 		case 0x705:
+		case 0x905:	/* GT-2AB */
+		case 0x1005:	/* GC-Q20 */
 			return TYPE_HXN;
 		}
 		break;


