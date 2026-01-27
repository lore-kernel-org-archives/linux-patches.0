Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28970327C10
	for <patches@lists.linux.dev>; Tue, 27 Jan 2026 18:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769539113; cv=none; b=HjJNxaWcbUfYv4iz9SbiLt8RkMs3Y8gnc1xtgbqq03Jj3h4Xpx9dBoKZ4AwHODhTZL5pQq1Vw7eOFFHamZDIXu6iUkjn1rBKl+rMf908RyIZlNe64SlrfciXbdk+jdPD6EDH3250ppIfyTDTr8JnY5m68xB7Hb9pZDgPUU28Ih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769539113; c=relaxed/simple;
	bh=teAZMbI2AVQL+quc4ICpSEwSioo/BAWZQCEXQEbu1eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=seo4AbFNzOeAXsgNDcIBvN22jqXmNqys0xx9ePsxRz8dR8YauVjBq6NDmPCG7yQVHH9sxVBqN+TSoJDDfnSZa7UjmGjicbsXSt5alMJQEB2PVuEgiYHzZJm2T7rkAmTPdnmQ5F7o/eIlzZrCnbu/TjPo/mOINF1C5XVNU/6pKAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Hq9QYCZT; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Hq9QYCZT"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 2E79E20B7165; Tue, 27 Jan 2026 10:38:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2E79E20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769539112;
	bh=QgepVqiF+kZbIdKMl73+/Ujwi+aEY2NJMBQV2clfcQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hq9QYCZTCg+F7FZcoWx9D0ok9FWUSj4bDYtjnIftWI6vKX/MuzDlPo/Qf8eCmho8d
	 Jq6TCKiKQ0I+qGV9BLlXdc0fSCjb/YJZf90h+nbybQLTXb2wsjTedDDceDgPlVcau+
	 Rl5iBUE/mb3kA2PJ/H22kJGiJSI8SPpqBxWm0Lh0=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: irogers@google.com,
	james.clark@linaro.org,
	leo.yan@arm.com,
	namhyung@kernel.org,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.6 176/737] perf arm-spe: Extend branch operations
Date: Tue, 27 Jan 2026 10:38:30 -0800
Message-ID: <20260127183832.458213-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260109112140.649989422@linuxfoundation.org>
References: <20260109112140.649989422@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

It appears that this patch broke the build, see:

In file included from util/arm-spe-decoder/arm-spe-pkt-decoder.h:10,
                 from util/arm-spe-decoder/arm-spe-pkt-decoder.c:14:
linux/tools/include/linux/bitfield.h: In function ‘le16_encode_bits’:
linux/tools/include/linux/bitfield.h:166:38: error: implicit declaration of function ‘cpu_to_le16’ [-Wimplicit-function-declaration]
  166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
      |                                      ^~~~~~~~~
linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
  149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
      |                ^~
linux/tools/include/linux/bitfield.h:170:1: note: in expansion of macro ‘__MAKE_OP’
  170 | __MAKE_OP(16)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘le16_get_bits’:
linux/tools/include/linux/bitfield.h:166:54: error: implicit declaration of function ‘le16_to_cpu’ [-Wimplicit-function-declaration]
  166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
      |                                                      ^~
linux/tools/include/linux/bitfield.h:163:17: note: in definition of macro ‘____MAKE_OP’
  163 |         return (from(v) & field)/field_multiplier(field);               \
      |                 ^~~~
linux/tools/include/linux/bitfield.h:170:1: note: in expansion of macro ‘__MAKE_OP’
  170 | __MAKE_OP(16)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘be16_encode_bits’:
linux/tools/include/linux/bitfield.h:167:38: error: implicit declaration of function ‘cpu_to_be16’ [-Wimplicit-function-declaration]
  167 |         ____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu) \
      |                                      ^~~~~~~~~
linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
  149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
      |                ^~
linux/tools/include/linux/bitfield.h:170:1: note: in expansion of macro ‘__MAKE_OP’
  170 | __MAKE_OP(16)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘be16_get_bits’:
linux/tools/include/linux/bitfield.h:167:54: error: implicit declaration of function ‘be16_to_cpu’ [-Wimplicit-function-declaration]
  167 |         ____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu) \
      |                                                      ^~
linux/tools/include/linux/bitfield.h:163:17: note: in definition of macro ‘____MAKE_OP’
  163 |         return (from(v) & field)/field_multiplier(field);               \
      |                 ^~~~
linux/tools/include/linux/bitfield.h:170:1: note: in expansion of macro ‘__MAKE_OP’
  170 | __MAKE_OP(16)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘le32_encode_bits’:
linux/tools/include/linux/bitfield.h:166:38: error: implicit declaration of function ‘cpu_to_le32’ [-Wimplicit-function-declaration]
  166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
      |                                      ^~~~~~~~~
linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
  149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
      |                ^~
linux/tools/include/linux/bitfield.h:171:1: note: in expansion of macro ‘__MAKE_OP’
  171 | __MAKE_OP(32)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘le32_get_bits’:
linux/tools/include/linux/bitfield.h:166:54: error: implicit declaration of function ‘le32_to_cpu’ [-Wimplicit-function-declaration]
  166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
      |                                                      ^~
linux/tools/include/linux/bitfield.h:163:17: note: in definition of macro ‘____MAKE_OP’
  163 |         return (from(v) & field)/field_multiplier(field);               \
      |                 ^~~~
linux/tools/include/linux/bitfield.h:171:1: note: in expansion of macro ‘__MAKE_OP’
  171 | __MAKE_OP(32)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘be32_encode_bits’:
linux/tools/include/linux/bitfield.h:167:38: error: implicit declaration of function ‘cpu_to_be32’ [-Wimplicit-function-declaration]
  167 |         ____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu) \
      |                                      ^~~~~~~~~
linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
  149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
      |                ^~
linux/tools/include/linux/bitfield.h:171:1: note: in expansion of macro ‘__MAKE_OP’
  171 | __MAKE_OP(32)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘be32_get_bits’:
linux/tools/include/linux/bitfield.h:167:54: error: implicit declaration of function ‘be32_to_cpu’ [-Wimplicit-function-declaration]
  167 |         ____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu) \
      |                                                      ^~
linux/tools/include/linux/bitfield.h:163:17: note: in definition of macro ‘____MAKE_OP’
  163 |         return (from(v) & field)/field_multiplier(field);               \
      |                 ^~~~
linux/tools/include/linux/bitfield.h:171:1: note: in expansion of macro ‘__MAKE_OP’
  171 | __MAKE_OP(32)
      | ^~~~~~~~~
  CC      util/thread.o
linux/tools/include/linux/bitfield.h: In function ‘le64_encode_bits’:
linux/tools/include/linux/bitfield.h:166:38: error: implicit declaration of function ‘cpu_to_le64’ [-Wimplicit-function-declaration]
  166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
      |                                      ^~~~~~~~~
linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
  149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
      |                ^~
linux/tools/include/linux/bitfield.h:172:1: note: in expansion of macro ‘__MAKE_OP’
  172 | __MAKE_OP(64)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘le64_get_bits’:
linux/tools/include/linux/bitfield.h:166:54: error: implicit declaration of function ‘le64_to_cpu’ [-Wimplicit-function-declaration]
  166 |         ____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu) \
      |                                                      ^~
linux/tools/include/linux/bitfield.h:163:17: note: in definition of macro ‘____MAKE_OP’
  163 |         return (from(v) & field)/field_multiplier(field);               \
      |                 ^~~~
linux/tools/include/linux/bitfield.h:172:1: note: in expansion of macro ‘__MAKE_OP’
  172 | __MAKE_OP(64)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘be64_encode_bits’:
  CC      util/thread_map.o
linux/tools/include/linux/bitfield.h:167:38: error: implicit declaration of function ‘cpu_to_be64’ [-Wimplicit-function-declaration]
  167 |         ____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu) \
      |                                      ^~~~~~~~~
linux/tools/include/linux/bitfield.h:149:16: note: in definition of macro ‘____MAKE_OP’
  149 |         return to((v & field_mask(field)) * field_multiplier(field));   \
      |                ^~
linux/tools/include/linux/bitfield.h:172:1: note: in expansion of macro ‘__MAKE_OP’
  172 | __MAKE_OP(64)
      | ^~~~~~~~~
linux/tools/include/linux/bitfield.h: In function ‘be64_get_bits’:
linux/tools/include/linux/bitfield.h:167:54: error: implicit declaration of function ‘be64_to_cpu’ [-Wimplicit-function-declaration]
  167 |         ____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu) \
      |                                                      ^~
linux/tools/include/linux/bitfield.h:163:17: note: in definition of macro ‘____MAKE_OP’
  163 |         return (from(v) & field)/field_multiplier(field);               \
      |                 ^~~~
linux/tools/include/linux/bitfield.h:172:1: note: in expansion of macro ‘__MAKE_OP’
  172 | __MAKE_OP(64)
      | ^~~~~~~~~

BR,
Hamza
