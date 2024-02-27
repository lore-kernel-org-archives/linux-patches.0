Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C7613B2A2;
	Tue, 27 Feb 2024 14:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042823; cv=none; b=VdMZQsvvuTCRSIH0WO+jZKOhgp6T5TQEaF5rmte8l3Z/mz+X24FH/uyryZ+6zAsHvEcsr75Tg3nSM+5wqXNwHkW0Djlq2LLVlWEnnOuK6SYfCzzSszIPxxDloAY8UNG3vsIRdml1q76gYjqrSpZfH1Y23yXGh4ig/KZLJnzK2hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042823; c=relaxed/simple;
	bh=cTpbqNR3jaIQgwJDZwTNJriLtT2P6pe9UcfY3X5IquY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjdEC3mjGv5ka9PC42FaXAJ/sWWay+FMyAHsLyrhpr+QTdd5z9xq/TsjqZXRkkj7hCGdgaME/RiVeF4j0IkNcD/3l6fNH+9aoIGKANj/pTunJuBXJa5gNUZbvkaMEnEmrneD0LFFgtJHRuzj4JQzlbx9FDZJTM5vafYsRqvB9W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSJyHxxG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSJyHxxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44E5C433C7;
	Tue, 27 Feb 2024 14:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042823;
	bh=cTpbqNR3jaIQgwJDZwTNJriLtT2P6pe9UcfY3X5IquY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSJyHxxGpTGDO9HUQH44UFvsG4kpOBecjfIH1LSfMuqGvCm01x6MQV7c/v4bLWHdk
	 YdKQRUfoOuhBSsl2PpPO95I2kaelcJhKZxp8RVuYg+vsWNvP1qOjbVQ8T+fYk+KR5w
	 iKpqZ6x6jS1tnxbUtn53zHnr4GWgnzlRHKwU9wcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/245] platform/x86: asus-wmi: Document the dgpu_disable sysfs attribute
Date: Tue, 27 Feb 2024 14:25:22 +0100
Message-ID: <20240227131619.567951665@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 7e64c486e807c8edfbd3a0c8e44ad7a1896dbec8 ]

The dgpu_disable attribute was not documented, this adds the
required documentation.

Fixes: 98829e84dc67 ("asus-wmi: Add dgpu disable method")
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20220812222509.292692-2-luke@ljones.dev
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index 04885738cf156..0f8f0772d6f3b 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -57,3 +57,12 @@ Description:
 			* 0 - default,
 			* 1 - overboost,
 			* 2 - silent
+
+What:		/sys/devices/platform/<platform>/dgpu_disable
+Date:		Aug 2022
+KernelVersion:	5.17
+Contact:	"Luke Jones" <luke@ljones.dev>
+Description:
+		Disable discrete GPU:
+			* 0 - Enable dGPU,
+			* 1 - Disable dGPU
-- 
2.43.0



