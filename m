Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90093B38AE;
	Fri, 24 Apr 2026 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038086; cv=none; b=AZMsrGU5JFFUiRd9YBtfwRSrLpZ/zorAnBxsFb339CJlnHzoaJUsSySbN23QoQbYXIaZYPtKEXWR8cTGvRrdI21Ub57exOqnhB4JmQaws+UTFrbExGmuU27+cwYWY9a1i0imqqgi65iMSGl71p/ypuzPirD9+w8qX9AbQYnZINA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038086; c=relaxed/simple;
	bh=hX3NMacI9kyK/lGeKYGQNgX778/wkoUZ1pkWma5747E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ierjzzHSBbgnE96upHxHhx8fD5lQzaXyMjosnD41oQ+LQPHH/tHtij8BUKi9/Ir95nHHd2IvVz/GgkSTmqGahoUHsAngBB8HzF9NzLOddLMU+C7uu4nDYIIunElG9l64wlf+oHL2LKRjNkr8ZgZm8dJx1ChDEonxoGZjYTHGdD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkx9t/Qi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkx9t/Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF42C19425;
	Fri, 24 Apr 2026 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038086;
	bh=hX3NMacI9kyK/lGeKYGQNgX778/wkoUZ1pkWma5747E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkx9t/QiEyCoU+sRWf2tlYdVkQm1B2Z8LQfygGYmsCNBJ/8fP5E8WLtKPK4BDc1VA
	 0nBdpq+DeC0h7WvAn5hubScH3MjpmHJXR6KGTttxzmoYqEQPnMwo3kf1kQxdK3Y8IM
	 he5Rg0PdqVChlAbTnRxbqP7mfFnNy5ospgOdlBPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-crypto@vger.kernel.org, kunit-dev@googlegroups.com, Eric Biggers" <ebiggers@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 19/55] lib/crc: tests: Add a .kunitconfig file
Date: Fri, 24 Apr 2026 15:30:58 +0200
Message-ID: <20260424132434.090213400@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit c13cee2fc7f137dd25ed50c63eddcc578624f204 upstream.

Add a .kunitconfig file to the lib/crc/ directory so that the CRC
library tests can be run more easily using kunit.py.  Example with UML:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crc

Example with QEMU:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crc --arch=arm64 --make_options LLVM=1

Link: https://lore.kernel.org/r/20260306033557.250499-4-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crc/.kunitconfig |    3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 lib/crc/.kunitconfig

--- /dev/null
+++ b/lib/crc/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_CRC_ENABLE_ALL_FOR_KUNIT=y
+CONFIG_CRC_KUNIT_TEST=y


