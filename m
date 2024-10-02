Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09981D0940;
	Wed,  2 Oct 2024 14:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879057; cv=none; b=dKNqr57C56J2TVeEQ0IvNgvtZ+3creYfftHOzHWG/Vi2izegSuik6aacCnYSU5IcN4Sc3Y/MaICSDAS7UkO9SFSE0o6NZBtpbGh1C3tiUcdFbAS8UxWMFyDzIO1BPiGyUbGPSQKenE6srJMExTEOI5Sl93U5oCgROKlCHbMFeCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879057; c=relaxed/simple;
	bh=ljzZsiq/XTvVuvAl7gzGkr6cS1S/zuvFUH6mnWX/Huw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBpUxdmEv8pszYf3Grb1jjEc3Rqhcvut1f7CqGnQLRr5TeyAgJ2WwwWV1vicq9+RTurYOGiYFhkm2ESD/jtPNN7wRyBSGcYf37NchIP/I3kRiHZJscMMaa45Bq4khMe4kAJGzVTQ28B26wFJ/HBxFRDDfHzDdKhN5c98IWLo8GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHIDjH3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHIDjH3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F89C4CEC2;
	Wed,  2 Oct 2024 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879056;
	bh=ljzZsiq/XTvVuvAl7gzGkr6cS1S/zuvFUH6mnWX/Huw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHIDjH3lUTU1QXnN6eTdqH+w4uAvm+cZOZZ6ublwAmcKVAdcukmyAzFAEPjGOlL38
	 cghlxS/UFy5Fb2YbINk7bFFolnhfz8zWplNmm7pknc0qiaRq7fRtDNE86DAiIUt6kW
	 IQGQ2T+diyA567gGPg5oXgoSCg0UI+zI4UMSafF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: [PATCH 6.10 624/634] module: Fix KCOV-ignored file name
Date: Wed,  2 Oct 2024 15:02:04 +0200
Message-ID: <20241002125835.756253255@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Vyukov <dvyukov@google.com>

commit f34d086fb7102fec895fd58b9e816b981b284c17 upstream.

module.c was renamed to main.c, but the Makefile directive was copy-pasted
verbatim with the old file name.  Fix up the file name.

Fixes: cfc1d277891e ("module: Move all into module/")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/bc0cf790b4839c5e38e2fafc64271f620568a39e.1718092070.git.dvyukov@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -5,7 +5,7 @@
 
 # These are called from save_stack_trace() on slub debug path,
 # and produce insane amounts of uninteresting coverage.
-KCOV_INSTRUMENT_module.o := n
+KCOV_INSTRUMENT_main.o := n
 
 obj-y += main.o
 obj-y += strict_rwx.o


